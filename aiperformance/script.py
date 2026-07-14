import datetime
import os
import random
import subprocess


ARCADIA = os.path.expanduser('~/arcadia')
PATH = ('~/arcadia/diehard/crossroad/internal/crossroad/lib'
        '/verificationcurrency/verification_currency.go')
PROJECT = os.path.join(ARCADIA, 'diehard')
ROOT = os.path.expanduser('~/arcadia/diehard/kvas')
YA = '/usr/local/bin/ya'


def random_path():
    files = []

    for dirname, dirnames, filenames in os.walk(ROOT):
        for filename in filenames:
            if filename.endswith('.go'):
                files.append(
                    os.path.relpath(
                        os.path.join(dirname, filename),
                        ARCADIA,
                    )
                )

    return random.choice(files)


def main():
    mypath = random_path()
    cmd = [
        YA, 'code', 'oc', 'run',
        (f'Что можно улучшить в {mypath}? '
         'Не трогай код, только напиши словами.'),
    ]

    time_now = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    script_dir = os.path.dirname(os.path.realpath(__file__))
    stdout_path = os.path.join(script_dir, f'logs/{time_now}.out')
    stderr_path = os.path.join(script_dir, f'logs/{time_now}.err')

    with open(stdout_path, 'w', encoding='utf-8') as stdout_file, open(
            stderr_path, 'w', encoding='utf-8') as stderr_file:
        stdout_file.write(f'FILE: {mypath}\n\n')
        stdout_file.flush()
        result = subprocess.run(
            cmd,
            input='\n',
            text=True,
            stdout=stdout_file,
            stderr=stderr_file,
            cwd=PROJECT,
            timeout=1200,
        )

    print(result.returncode)


if __name__ == '__main__':
    main()
