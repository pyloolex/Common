from abc import ABC, abstractmethod
import collections
import unittest

# Банкомат.
# Инициализируется набором купюр и умеет выдавать купюры для заданной суммы, либо отвечать отказом.
# При выдаче купюры списываются с баланса банкомата.
# Допустимые номиналы: 50₽, 100₽, 500₽, 1000₽, 5000₽.

class FailedWithdrawalError(Exception):
    pass


class ATM:
    NOMINALS = {
        'ruble': [50, 100, 500, 1000, 5000],
        'euro': [50, 100, 200],
    }

    def __init__(self, atm_sdk):
        self.atm_sdk = atm_sdk
        self.balance = {}
        for currency, nominals in self.NOMINALS.items():
            self.balance[currency] = {}
            for nominal in nominals:
                self.balance[currency][nominal] = (
                    self.atm_sdk.count_banknotes(currency, nominal))

    def withdraw(self, currency, amount):
        self.money_to_withdraw = collections.defaultdict(int)
        for i in range(len(self.NOMINALS[currency]) - 1, -1, -1):
            nominal = self.NOMINALS[currency][i]
            nom_count = min(self.balance[currency][nominal], amount // nominal)
            self.money_to_withdraw[nominal] += nom_count
            amount -= nom_count * nominal

        if amount:
            raise FailedWithdrawalError('Impossible to withdraw this amount.')

        for nominal, count in self.money_to_withdraw.items():
            self.atm_sdk.move_banknote_to_dispenser(currency, nominal, count)
            self.balance[currency][nominal] -= count

        self.atm_sdk.open_dispenser()


# API для взаимодействия с аппаратурой банкомата.
# Краткий ликбез по устройству банкомата:
# - деньги расположены в кассетах, кассеты устанавливаются инкассацией;
# - в каждой кассете лежат свои купюры, количество известно инкассатору при установке
# - банкомат может подсчитать оставшиеся в кассетах банкноты, но эта операция занимает около 10 секунд, и шумная, её стоит вызывать как можно реже.
# - интерфейс SDK может быть изменён/расширен по договорённости сторон, если это необходимо
class SDK(ABC):
    @abstractmethod
    def count_banknotes(self, currency: str, banknote: int) -> int:
        pass

    @abstractmethod
    def move_banknote_to_dispenser(
            self, currency: str, banknote: int, count: int) -> None:
        pass

    @abstractmethod
    def open_dispenser(self) -> None:
        pass

class MockSdk(SDK):
    def __init__(self, balance):
        self.balance = balance
        self.dispenser_was_opened = False

    def count_banknotes(self, currency: str, banknote: int) -> int:
        return self.balance[currency][banknote]

    def move_banknote_to_dispenser(
            self, currency: str, banknote: int, count: int) -> None:
        self.balance[currency][banknote] -= count

    def open_dispenser(self) -> None:
        self.dispenser_was_opened = True


class AtmTest(unittest.TestCase):
    def setUp(self, *args, **kwargs):
        super(AtmTest, self).setUp(*args, **kwargs)

    def _test_successful_withdrawal(
            self, currency, init_balance, amount, final_balance):
        sdk = MockSdk(init_balance)
        atm = ATM(sdk)

        atm.withdraw(currency, amount)

        self.assertDictEqual(
            final_balance,
            sdk.balance,
        )
        self.assertTrue(sdk.dispenser_was_opened)

    def test_one_nominal(self):
        self._test_successful_withdrawal(
            'ruble',
            {'ruble': {50: 3, 100: 3, 500: 3, 1000: 3, 5000: 3},
             'euro': {50: 2, 100: 5, 200: 2}},
            2000,
            {'ruble': {50: 3, 100: 3, 500: 3, 1000: 1, 5000: 3},
             'euro': {50: 2, 100: 5, 200: 2}},
        )

    def test_different_currencies(self):
        sdk = MockSdk(
            {'ruble': {50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2},
             'euro': {50: 1, 100: 2, 200: 3}})
        atm = ATM(sdk)
        atm.withdraw('ruble', 14050)

        self.assertDictEqual(
            {'ruble': {50: 0, 100: 2, 500: 1, 1000: 0, 5000: 0},
             'euro': {50: 1, 100: 2, 200: 3}},
            sdk.balance,
        )
        self.assertTrue(sdk.dispenser_was_opened)
        sdk.dispenser_was_opened = False

        atm.withdraw('euro', 350)
        self.assertDictEqual(
            {'ruble': {50: 0, 100: 2, 500: 1, 1000: 0, 5000: 0},
             'euro': {50: 0, 100: 1, 200: 2}},
            sdk.balance,
        )
        self.assertTrue(sdk.dispenser_was_opened)

    '''
    def test_zero_final_balance(self):
        self._test_successful_withdrawal(
            {50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2},
            14750,
            {50: 0, 100: 0, 500: 0, 1000: 0, 5000: 0},
        )

    def test_multiple_withdrawals(self):
        sdk = MockSdk({50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2})
        atm = ATM(sdk)

        atm.withdraw(14700)

        self.assertDictEqual(
            {50: 1, 100: 0, 500: 0, 1000: 0, 5000: 0},
            sdk.balance,
        )
        self.assertTrue(sdk.dispenser_was_opened)
        sdk.dispenser_was_opened = False

        atm.withdraw(50)
        self.assertDictEqual(
            {50: 0, 100: 0, 500: 0, 1000: 0, 5000: 0},
            sdk.balance,
        )
        self.assertTrue(sdk.dispenser_was_opened)

    def test_amount_non_divisible_by_50(self):
        sdk = MockSdk({50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2})
        atm = ATM(sdk)

        exc = self.assertRaises(
            FailedWithdrawalError,
            atm.withdraw,
            75,
        )

        self.assertDictEqual(
            {50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2},
            sdk.balance,
        )
        self.assertFalse(sdk.dispenser_was_opened)

    def test_not_enough_banknotes(self):
        sdk = MockSdk({50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2})
        atm = ATM(sdk)

        exc = self.assertRaises(
            FailedWithdrawalError,
            atm.withdraw,
            15000,
        )

        self.assertDictEqual(
            {50: 1, 100: 2, 500: 1, 1000: 4, 5000: 2},
            sdk.balance,
        )
        self.assertFalse(sdk.dispenser_was_opened)
    '''

if __name__ == '__main__':
    unittest.main()
