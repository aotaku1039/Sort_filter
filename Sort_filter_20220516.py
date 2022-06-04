import os
os.system("cls") #コンソール画面消去

import time
import re

#import pyperclip


#テトリスにおいて、path-filterの結果をpath-unique準拠で並び替えるプログラム
#A program that sorts the results of path-filter according to path-unique in Tetris.


#大体の情報はこちらから
#Click here for basic information.
#https://paiza.io/projects/SMAz63pPLr2S5ewstdRfag


input_tetfus = ["", ""] #入力テト譜 0...filterURL 1...uniqueURL
output_type = 0 #出力形式



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
            

print("path-filterのURLを貼り付けて、Enterキーを押してください")
print("Paste the path-filter URL and press Enter.")
print("")
input_tetfus[0] = inputTetfu()

print("")
print("")
print("path-uniqueのURLを貼り付けて、Enterキーを押してください")
print("Paste the path-unique URL and press Enter.")
print("")
input_tetfus[1] = inputTetfu()

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




def getDivMod(x, y): #割り算して商と余りを返す
    return (x // y), (x % y)

def cutTetfuText(tetfu): #テト譜文字列から「?」や最初部分など、不要な部分を取り除く
    start = tetfu.find("@")
    tetfu = tetfu[start + 1 :]  #最初の不要部分を取り除く
    
    tetfu = tetfu.replace("?", "")  #「?」を取り除く
    tetfu = tetfu.replace(" ", "")  #空白を取り除く
    tetfu = re.sub("\n", "", tetfu) #改行を取り除く
    
    return tetfu



DATA_FORMAT_TEXT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" #文字と数字を変換する用
COMMENT_TABLE = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"  #コメントと数字を変換する用



def formatNum(num, textcnt, table): #数字を文字に変換
    cnt = num #引き算していく用
    before_cnt = 0 #引く前の値調整
    text = "" #文字列の足し算
    
    for i in reversed(range(textcnt)):#指定文字列分だけ、後ろからループする
        if table == 0: #単なる文字と数字の変換、64文字テーブル
            j = 64 ** i #64^iの記述をまとめる用
            before_cnt = cnt // j #64^i の何倍が含まれてるか計算
            text = DATA_FORMAT_TEXT[before_cnt] + text #文字変換し、前に足す
        else:
            j = 96 ** i #96^iの記述をまとめる用
            before_cnt = cnt // j #96^i の何倍が含まれてるか計算
            text = COMMENT_TABLE[before_cnt] + text #文字変換し、前に足す
        
        cnt -= before_cnt * j #不要になった数値は引いて消す
    
    return text


def formatText(text, table): #文字を数字に変換
    cnt = 0 #足し算用
    before_cnt = 0 #足し算前の値調整
    
    for i in range(len(text)): #文字数の分だけループして足していく
        if table == 0: #単なる文字と数字の変換、64文字テーブル
            before_cnt = DATA_FORMAT_TEXT.find(text[i])
            before_cnt *= (64 ** i)
        else: #コメント用、95+余り1の96文字テーブル
            before_cnt = COMMENT_TABLE.find(text[i])
            before_cnt *= (96 ** i)
        
        cnt += before_cnt
    
    return cnt


input_tetfus[0] = cutTetfuText(input_tetfus[0])
input_tetfus[1] = cutTetfuText(input_tetfus[1])

#print(input_tetfus[1])


field_blocks    = [] #filterとuniqueのブロック番号を格納する配列　添字を480で割った商がページ数(-1) 、余りが 0~239...filter座標、240~479...unique座標(すべてブロック番号)
unique_comments = [] #uniqueのコメントを格納する配列




def decodeTextField(page): #文字をフィールドにデコード
    for i in range(480):
        field_blocks.append(0) #1ページのデコードにつき、フィールド情報の変数には480の要素をpush
    
    for i in range(2):
        totalcnt = 0
        
        while(True):
            if input_tetfus[i] == "": #もし取り出そうとした2文字が空、つまりそのテト譜のすべてのページのデコードが終了したあとなら　nilのまま放置してすぐwhileループを抜ける
                break
            else: #もし取り出そうとした2文字が空ではない、つまりそのテト譜のすべてのページのデコードがまだ終了していないなら　nilを数値に置き換えていく
                val =input_tetfus[i][:2] #入力データから頭2文字を取り出す
                input_tetfus[i] = input_tetfus[i][2:] #取り出した2文字は消す
                
                val = formatText(val, 0)  #数字変換してvalに格納
                
                diff,cnt = getDivMod(val, 240) #valを240で割り、商をdiffに、余りをcntに入れる
                
                for loca in range(cnt + 1):
                    field_blocks[totalcnt + loca + i * 240 + page * 480] = diff - 8 #0~479がページ、0~239がfilter、240~479がunique
                
                totalcnt += cnt + 1
                if totalcnt >= 240: #240ブロック分デコードできたら　whileループを抜ける
                    break
                
                

def decodeUniqueFlagComment(page): #uniqueのコメントフラグとコメントをデコード
    unique_comments.append("")
    
    for i in range(2): #記録するのはuniqueだけでいいが、filterも同じ手順を踏んで文字列を取り出しておかないといけない
        flag = input_tetfus[i][:3] #コメントフラグのオンオフ調べ　入力データから頭3文字を取り出す
        input_tetfus[i] = input_tetfus[i][3:] #取り出した3文字は消す
        
        if flag == "AAA": #AAAはAgHに、AAPはAgWにすることで　フラグ文字列を2種類だけに絞る
            flag = "AgH"
        elif flag == "AAP":
            flag = "AgW"
        
        
        if flag == "AgW":
            slicetext = input_tetfus[i][:2] #頭2文字を取り出す
            input_tetfus[i] = input_tetfus[i][2:]
            
            textcnt = formatText(slicetext, 0) #文字数
            
            textcntdiv4, textcntmod4 = getDivMod(textcnt, 4)
            
            if textcntmod4 != 0: #余りがあれば、切り上げて商に1を加える
                textcntdiv4 += 1
            
            totaltext = "" #すべての文字の合計を記録する用
            
            
            for j in range(textcntdiv4):
                text = input_tetfus[i][:5] #5文字取り出す
                input_tetfus[i] = input_tetfus[i][5:]
                num = formatText(text, 0) #数字にする
                text = formatNum(num, 4, 1) #係数96で4文字にする
                
                totaltext += text #結合していく
            
            totaltext = totaltext.rstrip() #末尾の「 」paddingを消す
            
        else:
            totaltext = unique_comments[page - 1] #前のページのコメントをそのままもってくる
        
    unique_comments[page] = totaltext
    
    
    
    
page = 0

while(True):
    if input_tetfus[1] == "":
        break
    
    decodeTextField(page)
    decodeUniqueFlagComment(page)
    
    page += 1



# for i in input_tetfus:
#     print(i)
    
# for i in field_blocks:
#     print(i)
    
# for i in unique_comments:
#     print(i)
    
# print(page)



def comparisonAndNewConstruction(pagecnt): #filterとuniqueの比較と、テト譜文字列の新構築
    
    filter_texts = [] #それぞれfilter、uniqueのブロック情報を文字列にして繋ぎ合わせたものを格納する配列　添字は今いるページ数-1、要素数はuniqueのページ数で1要素につき240文字入れる
    unique_texts = []
    
    for pagenow in range(pagecnt): #uniqueのページ数分だけ、配列にpushしたり、値を入れたりしていく
        filter_texts.append("") #とりあえず""をpushしておく
        unique_texts.append("")
        
        for locanow in range(240):
            filter_texts[pagenow] += str(field_blocks[pagenow * 480 + 0 * 240 + locanow]) #ブロック番号を文字列化して、240文字繋げて配列に格納する 
            unique_texts[pagenow] += str(field_blocks[pagenow * 480 + 1 * 240 + locanow])
            
    
    sort_filters = [] #filter並び替えの情報を入れていく配列　1ページにつき要素2つ、添字の余りが0...ブロック番号文字列、1...そのページのコメント文字列
    constructed_page = 0 #できあがったページ数
    
    
    for pagenow in range(pagecnt):
        if (unique_texts[pagenow] in filter_texts) == True:
            for i in range(2):
                sort_filters.append("")
            
            sort_filters[constructed_page * 2 + 0] = unique_texts[pagenow]
            sort_filters[constructed_page * 2 + 1] = unique_comments[pagenow]
            
            constructed_page += 1
    
    return sort_filters


sort_filters = []
sort_filters = comparisonAndNewConstruction(page)
pagecnt = (len(sort_filters) // 2) #filter並び替え情報配列の要素数を2で割った商が、ページ数



def encodeFieldText(pagenow): #フィールドデータを文字列にエンコード1
    curr_field_text = sort_filters[pagenow * 2 + 0]
    prev_field_text = "0" * 240 #パフェかつ接着フラグがONなので、前のページはすべて空判定となる
    
    return _encodeFieldText(curr_field_text, prev_field_text) #2に繋げる
    

def _encodeFieldText(curr_field_text, prev_field_text): #フィールドデータを文字列にエンコード2
    encoded_text = "" #エンコードが完了した文字を結合していく用
    
    prevdiff = 0 #前回のdiff値と今回のdiff値に分けることで、変化を検知しやすくする
    currdiff = int(curr_field_text[0]) + 8 #先頭のdiff値で初期化する
    
    index = 1 #現在チェックしている位置を保存する用 先頭は初期値に含まれているので、その次のブロックから開始する
    
    while (index < 240): #240ブロックエンコードできるまでループ
        cnt = 0 #前回と今回のdiff値が同じである回数を数える用
        
        while (index < 240): #240ブロックエンコードできるまでループ
            curr = int(curr_field_text[index]) #今回調べる座標のブロック番号を数値化
            prev = int(prev_field_text[index]) #前回調べた座標のブロック番号を数値化
            
            prevdiff = currdiff  #今回の座標を上書きする前に、前回の座標に値渡ししておく
            currdiff = curr - prev + 8
            
            index += 1
            
            if prevdiff != currdiff:
                break
            else:
                cnt += 1
        
        val = prevdiff * 240 + cnt
        encoded_text += formatNum(val, 2, 0)
        
    return encoded_text #エンコードが完了したら、できた文字列を関数外に返す
        

def encodeCommentText(pagenow): #(コメントフラグと)コメントデータを文字列にエンコード
    comment_text = sort_filters[pagenow * 2 + 1] #今いるページのコメント文字列
    encoded_text = "AgW"
    
    encoded_text += formatNum(len(comment_text), 2, 0) #文字数記録
    
    div4, mod4 = getDivMod(len(comment_text), 4)
    
    if mod4 != 0:
        div4 += 1
        comment_text += (" " * (4 - mod4)) #(4 - 文字数を4で割ったあまり)の数だけ、末尾を「 」でpaddingし、商を1増やす
        
    
    for i in range(div4):
        text = comment_text[:4]
        comment_text = comment_text[4:]
        
        num = formatText(text, 1)
        encoded_text += formatNum(num, 5, 0)
    
    return encoded_text




encoded_text = "" #エンコードされた文字列を結合する用

for pagenow in range(pagecnt):
    #print(encodeFieldText(pagenow))
    encoded_text += encodeFieldText(pagenow)
    #print(encodeCommentText(pagenow))
    encoded_text += encodeCommentText(pagenow)
    


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


result_url = selectEncodeFormat(output_type, encoded_text)


os.system("cls") #コンソール画面消去

print("結果URL  result URL")
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
