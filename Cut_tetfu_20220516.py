import os
os.system("cls") #コンソール画面消去

import time
import re


input_tetfu = ""
output_type = 0


def inputTetfu():
    while True:
        input_tetfu = input()
        if input_tetfu != "\n":
            break
    return input_tetfu

def inputType(): #出力形式
    while True:
        input_text = input()
        if input_text.isdecimal():
            input_num = int(input_text)
            if 0 <= input_num <= 8: #0以上8以下の数値が打ち込まれていたときだけ通す
                return input_num

print("テト譜URLを貼り付けて、Enterキーを押してください")
print("Paste the tetfu URL and press Enter.")
print("")
input_tetfu = inputTetfu()

print("")
print("")
print("出力形式を0~8の数値で入力し、Enterキーを押してください")
print("Enter the output format as a number from 0 to 8 and press the Enter key.")
print("")
print("0...RAW DATA(v115@スタート)")
print("1...日本版のEdit形式(https://fumen.zui.jp/?v115@スタート)")
print("2...日本版のFullList形式(https://fumen.zui.jp/?d115@スタート)")
print("3...日本版のMiniList形式(https://fumen.zui.jp/?D115@スタート)")
print("4...日本版のView形式(https://fumen.zui.jp/?m115@スタート)")
print("5...モバイル版(https://knewjade.github.io/fumen-for-mobile/#?d=v115@スタート)")
print("6...HardDrop版のEdit形式(https://harddrop.com/fumen/?v115@スタート)")
print("7...HardDrop版のList形式(https://harddrop.com/fumen/?d115@スタート)")
print("8...HardDrop版のView形式(https://harddrop.com/fumen/?m115@スタート)")
print("")
output_type = inputType()


def cutTetfuText(tetfu): #テト譜文字列から「?」や最初部分など、不要な部分を取り除く
    start = tetfu.find("@")
    tetfu = tetfu[start + 1 :]  #最初の不要部分を取り除く
    
    tetfu = tetfu.replace("?", "")  #「?」を取り除く
    tetfu = tetfu.replace(" ", "")  #空白を取り除く
    tetfu = re.sub("\n", "", tetfu) #改行を取り除く
    
    return tetfu


before_length = len(input_tetfu)


input_tetfu = cutTetfuText(input_tetfu)


def selectEncodeFormat(type, text):
    
    if type == 1: #1...日本版のEdit形式
        plustext = "https://fumen.zui.jp/?v115@"
    elif type == 2: #2...日本版のFullList形式
        plustext = "https://fumen.zui.jp/?d115@"
    elif type == 3: #3...日本版のMiniList形式
        plustext = "https://fumen.zui.jp/?D115@"
    elif type == 4: #4...日本版のView形式
        plustext = "https://fumen.zui.jp/?m115@"
    elif type == 5: #5...モバイル版
        plustext = "https://knewjade.github.io/fumen-for-mobile/#?d=v115@"
    elif type == 6: #6...HardDrop版のEdit形式
        plustext = "https://harddrop.com/fumen/?v115@"
    elif type == 7: #7...HardDrop版のList形式
        plustext = "https://harddrop.com/fumen/?d115@"
    elif type == 8: #8...HardDrop版のView形式
        plustext = "https://harddrop.com/fumen/?m115@"
    else: #0...RAW DATA(v115@スタート)
        plustext = "v115@"
        
    return plustext + text


result_url = selectEncodeFormat(output_type, input_tetfu)

after_length = len(result_url)

os.system("cls") #コンソール画面消去

print(f"結果URL  result URL  {before_length}文字 → {after_length}文字")
print("")
print(result_url)
print("")


print("URLをドラッグして選択し、Ctrl+Cキーでコピーしてください")
print("Drag the URL to select it and press Ctrl + C to copy it.")
print("")
print("コピーできたら、なにもドラッグせずにCtrl+Cキーを押してプログラムを終了させてください")
print("After copying, press Ctrl + C without dragging anything to exit the program.")
while (True):
    time.sleep(1)
