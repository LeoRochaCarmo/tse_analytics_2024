
from zipfile import ZipFile
import os
from pathlib import Path

data_folder = 'data'

path = os.path.join(Path(__file__).parent, data_folder)

files = os.listdir(path)

for file in files:
    if file.endswith('.zip'):
        zip_path = os.path.join(path, file)
        with ZipFile(zip_path, mode='r') as zipfile:
            zipfile.extractall(os.path.join(path, file.replace('.zip','')))

        os.remove(zip_path)

