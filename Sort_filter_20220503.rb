print "\e[H\e[2J" #画面消去

#テトリスにおいて、path-filterの結果をpath-unique準拠で並び替えるプログラム
#A program that sorts the results of path-filter according to path-unique in Tetris.


#大体の情報はこちらから
#Click here for basic information.
#https://paiza.io/projects/SMAz63pPLr2S5ewstdRfag


$arr_input_data = ["", "", 0] #入力データ 0...filterURL 1...uniqueURL 2...出力形式


def inputData(index)
    while 1
        $arr_input_data[index] = gets
        if $arr_input_data[index] != "\n"
            break
        end
    end
end


puts "path-filterのURLを貼り付けて、Enterキーを押してください"
puts "Paste the path-filter URL and press Enter."
inputData(0)

puts ""
puts "path-uniqueのURLを貼り付けて、Enterキーを押してください"
puts "Paste the path-unique URL and press Enter."
inputData(1)

puts ""
puts "出力形式を数値で入力し、Enterキーを押してください"
puts "Input the output type as a number and press Enter."
puts ""
puts "0...RAW DATA(v115@スタート)"
puts "1...通常(https://fumen.zui.jp/?v115@スタート)"
puts "2...モバイル版(https://knewjade.github.io/fumen-for-mobile/#?d=v115@スタート)"
puts "3...HardDrop版(https://harddrop.com/fumen/?v115@スタート)"
puts "4...FullのList形式(https://fumen.zui.jp/?d115@スタート)"
puts "5...MiniのList形式(https://fumen.zui.jp/?D115@スタート)"
puts "6...View形式(https://fumen.zui.jp/?m115@スタート)"
puts ""
puts "指定がこれら以外ですとRAW DATAになります"
puts "If the specification is other than these, it will be RAW DATA."
$arr_input_data[2] = gets.to_i








def getDivMod(num1, num2) #割り算して商と余りを返す
    return (num1 / num2), (num1 % num2)
end


#a, b = getDivMod(30,4)
#p a, b

def cutTetfuText(tetfu) #テト譜文字列から「?」や最初部分など、不要な部分を取り除く
    start = tetfu.index("@") #最初の不要部分を取り除く
    tetfu[0, start + 1] = ""
    
    tetfu.delete!("?") #「?」を取り除く
    tetfu.delete!(" ") #空白を取り除く
    tetfu.delete!("\n")#改行を取り除く
    
    return tetfu
end



def escape(text) #JavaScript特有のescape()仕様
    text.gsub!("%","%25")
    text.gsub!(" ","%20")
    text.gsub!("!","%21")
    text.gsub!("\"","%22")
    text.gsub!("#","%23")
    text.gsub!("$","%24")
    text.gsub!("&","%26")
    text.gsub!("\'","%27")
    text.gsub!("(","%28")
    text.gsub!(")","%29")
    text.gsub!(",","%2C")
    text.gsub!(":","%3A")
    text.gsub!(";","%3B")
    text.gsub!("<","%3C")
    text.gsub!("=","%3D")
    text.gsub!(">","%3E")
    text.gsub!("?","%3F")
    text.gsub!("[","%5B")
    text.gsub!("\\","%5C")
    text.gsub!("]","%5D")
    text.gsub!("^","%5E")
    text.gsub!("`","%60")
    text.gsub!("{","%7B")
    text.gsub!("|","%7C")
    text.gsub!("}","%7D")
    text.gsub!("~","%7E")
    
    return text
end

def unescape(text) #JavaScript特有のunescape()仕様
    text.gsub!("%20"," ")
    text.gsub!("%21","!")
    text.gsub!("%22","\"")
    text.gsub!("%23","#")
    text.gsub!("%24","$")
    text.gsub!("%25","%")
    text.gsub!("%26","&")
    text.gsub!("%27","\'")
    text.gsub!("%28","(")
    text.gsub!("%29",")")
    text.gsub!("%2C",",")
    text.gsub!("%3A",":")
    text.gsub!("%3B",";")
    text.gsub!("%3C","<")
    text.gsub!("%3D","=")
    text.gsub!("%3E",">")
    text.gsub!("%3F","?")
    text.gsub!("%5B","[")
    text.gsub!("%5C","\\")
    text.gsub!("%5D","]")
    text.gsub!("%5E","^")
    text.gsub!("%60","`")
    text.gsub!("%7B","{")
    text.gsub!("%7C","|")
    text.gsub!("%7D","}")
    text.gsub!("%7E","~")
    
    return text
end


#p escape("76.3 % : ZIJSOTL")

def checkFlag(num) #数値からフラグを確かめる
  num2 = num

  puts "PIECE種類...#{(num % 8)}"
  num /= 8

  puts "PIECE向き...#{(num % 4)}"
  num /= 4

  puts "PIECE位置...#{(num % 240)}"
  num /= 240

  puts "せりあがりフラグ...#{(num % 2)}"
  num /= 2

  puts "鏡フラグ...#{(num % 2)}"
  num /= 2

  puts "色フラグ...#{(num % 2)}"
  num /= 2

  puts "コメントフラグ...#{(num % 2)}"
  num /= 2

  puts "接着フラグ(0ならオン)...#{(num)}"
  puts num2
  puts ""
end

def getNumFromFlag(piece, rotation, location, flag_raise, flag_mirror, flag_color, flag_comment, flag_lock) #フラグから数値を得る flag_lockは0がオン
  num = flag_lock
  num = num * 2 + flag_comment
  num = num * 2 + flag_color
  num = num * 2 + flag_mirror
  num = num * 2 + flag_raise
  num = num * 240 + location
  num = num * 4 + rotation
  num = num * 8 + piece

  puts num
  puts ""
end

#getNumFromFlag(0, 0, 0, 0, 0, 1, 1, 0)

#checkFlag(30720) #AgH
#checkFlag(92160) #AgW
#checkFlag(153600) #Agl
#checkFlag(61440) #AAP
#checkFlag(122880)










$data_format_text = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" #文字と数字を変換する用
$comment_table = "" #コメントと数字を変換する用

i = 0 #forカウント
for i in 0+32..94+32 do
    $comment_table += i.chr #ASCIIの32~126番目を入れていく
end





def formatNum(num, textcnt, table) #数字を文字に変換
    
    i = 0 #forカウント
    cnt = num #引き算していく用
    before_cnt = 0 #引く前に値を調整する
    text = "" #文字列の足し算用
    
    for i in 0 .. textcnt - 1 do #指定文字列分だけ、後ろからループする
        i = (textcnt - 1) - i
        
        if (table == 0) #単なる文字と数字の変換、64文字テーブル
            ii=(64 ** i) #64^iの記述をまとめる用
            before_cnt = cnt / ii #64^i の何倍が含まれてるか計算
            #p before_cnt
            text = $data_format_text.slice(before_cnt) + text #文字変換し、前に足す
            
        else #コメント用、95+余り1の96文字テーブル
            ii = (96 ** i) #96^iの記述をまとめる用
            before_cnt = cnt / ii #96^i の何倍が含まれてるか計算
            #p before_cnt
            #text = ( escape ( $comment_table.slice ( before_cnt ) ) ) + text #escape()もしつつ文字変換し、前に足す
            text = (  $comment_table.slice ( before_cnt ) ) + text #escape()はせずに文字変換し、前に足す
        end
        
        cnt -= before_cnt * ii #不要になった数値は引いて消す
    end
    
    return text
end

def formatText(text, table) #文字を数字に変換
    
    i = 0 #forカウント
    cnt = 0 #足し算していく用
    before_cnt = 0 #足す前に値を調整する
    
    
    for i in 0 .. text.length - 1 do #文字数の分だけループして足していく
        
        if (table == 0) #単なる文字と数字の変換、64文字テーブル
            before_cnt = $data_format_text.index(text[i])
            #p before_cnt
            before_cnt *= (64 ** i) #2文字目以降なら、64の(i文字目 - 1)乗をかける
            
            
        else #コメント用、95+余り1の96文字テーブル
            before_cnt = $comment_table.index(text[i])
            before_cnt *= (96 ** i) #2文字目以降なら、96の(i文字目 - 1)乗をかける
        end
        
        cnt += before_cnt
    end
    
    return cnt
end

def formatNumArr(num, arrindex, table)#1つの数字を複数の数字に分解する
    
    i = 0 #forカウント
    cnt = num #引き算していく用
    before_cnt = 0 #引く前に値を調整する
    arr_num = [] #数字を押し込む用(unshiftで前へ前へ押し込む)
    
    for i in 0 .. arrindex - 1 do #ほしい数字の数だけ、後ろからループする
        i = (arrindex - 1) - i
        
        if (table == 0) #係数64
            ii=(64 ** i) #64^iの記述をまとめる用
            before_cnt = cnt / ii #64^i の何倍が含まれてるか計算

        else #係数96
            ii = (96 ** i) #96^iの記述をまとめる用
            before_cnt = cnt / ii #96^i の何倍が含まれてるか計算
        end
        
        arr_num.unshift before_cnt
        cnt -= before_cnt * ii #不要になった数値は引いて消す
    end
    
    return arr_num

end

def formatArrNum(arr_num, table)#複数の数字をまとめて1つの数字にする
    i = 0 #forカウント
    cnt = 0 #足し算していく用
    before_cnt = 0 #足す前に値を調整する
    
    for i in 0 .. arr_num.length - 1 do #配列の要素数の分だけループして足していく
        
        before_cnt = arr_num[i]
        #p before_cnt
        
        if (table == 0) #係数64
            before_cnt *= (64 ** i) #2文字目以降なら、64の(i文字目 - 1)乗をかける
        else #係数96
            before_cnt *= (96 ** i) #2文字目以降なら、96の(i文字目 - 1)乗をかける
        end
        
        cnt += before_cnt
    end
    
    return cnt
end




#p formatNum(35,4,1)
#p formatText("zg",0)
#p formatNumArr(14322177,4,1)
#p formatArrNum([33, 5, 18, 16],1)



$arr_input_data[0] = cutTetfuText($arr_input_data[0])
$arr_input_data[1] = cutTetfuText($arr_input_data[1])



#p $arr_input_data[0]
#p $arr_input_data[1]
#p $arr_input_data[2]




$arr_field_block    = [] #filterとuniqueのブロック番号を格納する配列　添字を480で割った商がページ数(-1) 、余りが 0~239...filter座標、240~479...unique座標(すべてブロック番号)
$arr_unique_comment = [] #uniqueのコメントを格納する配列 


def decodeTextField(page) #文字をフィールドにデコード
    
    i = 0
    
    for i in 1..480 #1ページのデコードにつき、フィールド情報の変数には480の要素をpush
        $arr_field_block.push(0)
    end
    
    
    filter0_unique1 = 0
    
    
    for filter0_unique1 in 0..1 do #iの値が0のときfilter、1のときuniqueのデータをデコードする
        
        totalcnt = 0 #cntの合計　すなわちデコードしたブロックの数の合計
        #p i
        
        while 1 do
            val = $arr_input_data[filter0_unique1].slice!(0, 2)#入力データから頭2文字を取り出す
            if val != "" #もし取り出した2文字が空ではない、つまりそのテト譜のすべてのページのデコードがまだ終了していないなら　nilを数値に置き換えていく
                
                
                val =  formatText(val , 0) #数字変換してvalに格納
                
                diff, cnt = getDivMod(val, 240) #valを240で割り、商をdiffに、余りをcntに入れる
                
                loca = 0
                for loca in 0..cnt do #cnt+1の回数分だけループする
                    
                    if page == 0 #前のページのブロック番号を取得する
                        prev = 0 #1ページ目の場合、前となる0ページ目はすべて空白(0)
                    else #2ページ目以降の場合
                        prev = $arr_field_block[totalcnt + loca + filter0_unique1 * 240 + (page - 1) * 480 ]
                        #p totalcnt + loca + filter0_unique1 * 240 + (page - 1) * 480 
                    end
                    
                    $arr_field_block[totalcnt + loca + filter0_unique1 * 240 + (page - 0) * 480 ] =  + diff - 8 #0~479がページ、0~239がfilter、240~479がunique
                    
                    #p totalcnt + ii + i * 240 + page * 480
                    #print "番目 "
                    #print "prev + diff - 8 =           #{prev} + #{diff} - 8 = "
                    #p curr
                end
                
                totalcnt += cnt + 1
                if totalcnt >= 240 #240ブロック分デコードできたら　whileループを抜ける
                    break
                end
                
            else
                break #もし取り出した2文字が空、つまりそのテト譜のすべてのページのデコードが終了したあとなら　nilのまま放置してすぐwhileループを抜ける
            end
        end
    end
    
    
end



def decodeUniqueFlagComment(page) #uniqueのコメントフラグとコメントをデコード
    
    i = 0
    
    $arr_unique_comment.push(nil) #1ページにつき1つずつ要素をpush
    
    #記録するのはuniqueだけでいいが、filterも同じ手順を踏んで文字列を取り出しておかないといけない
    
    for i in 0..1 do
        flag = $arr_input_data[i].slice!(0, 3) #まずはコメントフラグのオンオフ調べから　頭3文字を取り出す
        if flag == "AAA" #AAAはAgHに、AAPはAgWにすることで　フラグ文字列を2種類だけに絞る
            flag = "AgH"
        elsif flag == "AAP"
            flag = "AgW"
        end
        
        if flag == "AgW" #コメントフラグがオンのとき 
            textcnt = formatText( $arr_input_data[i].slice!(0, 2), 0 ) #頭2文字を取り出し、数字変換したものが文字数
            #p textcnt
            textcntdiv4, textcntmod4 = getDivMod(textcnt, 4)#文字数を4で割って、商と余りを出す
            #p textcntdiv4
            #p textcntmod4
            
            if textcntmod4 != 0 #あまりがあれば、切り上げて商に1を加える
                textcntdiv4 += 1
            end
            
            #p textcntdiv4
            
            ii = 0
            totaltext = "" #すべての文字の合計を記録する用
            
            for ii in 1..textcntdiv4 do #余りを切り上げた上での商の数だけループする
                text = $arr_input_data[i].slice!(0, 5) #5文字取り出す
                num = formatText(text, 0) #数字にする
                text = formatNum(num, 4, 1) #係数96で4文字にする
                #p ii
                #p text
                totaltext += text #結合していく
            end
            
            
            totaltext.rstrip! #末尾の「 」paddingを消す
                        
        else #コメントフラグがオフのとき
            totaltext = $arr_unique_comment[page - 1] #前のページのコメントをそのままもってくる
        end
    end
    
    $arr_unique_comment[page] = totaltext
    
end



page = 0

while 1 do
    if $arr_input_data[1] == ""
       break
    end
    
    decodeTextField(page)
    decodeUniqueFlagComment(page)
    
    page += 1
end

#p $arr_input_data
#p $arr_field_block
#p $arr_unique_comment
#p page







def comparisonAndNewConstruction(pagecnt) #filterとuniqueの比較と、テト譜文字列の新構築
    
    arr_filter_text = [] #それぞれfilter、uniqueのブロック情報を文字列にして繋ぎ合わせたものを格納する配列　添字は今いるページ数-1、要素数はuniqueのページ数で1要素につき240文字入れる
    arr_unique_text = []
    unique_page = pagecnt - 1 #uniqueのページ数 - 1を入れておく
    
    page = 0 #現在のページ番号 - 1
    loca = 0 #現在の位置
    
    for page in 0..unique_page do #uniqueのページ数分だけ、配列にpushしたり、値を入れたりしていく
        
        arr_filter_text.push("") #とりあえず""をpushしておく
        arr_unique_text.push("")
        
        for loca in 0..239 do
            arr_filter_text[page] += ($arr_field_block[page*480 + 0*240 + loca]).to_s #ブロック番号を文字列化して、240文字繋げて配列に格納する 
            arr_unique_text[page] += ($arr_field_block[page*480 + 1*240 + loca]).to_s 
        end
        
    end
    
    #p arr_filter_text
    #p arr_unique_text
    
    
    
    arr_sortfilter = [] #filter並び替えの情報を入れていく配列　1ページにつき要素2つ、添字の余りが0...ブロック番号文字列、1...そのページのコメント文字列
    constructed_pages = 0 #できあがったページ数
    
    for page in 0..unique_page do
                
        if arr_filter_text.include?(arr_unique_text[page]) == true #uniqueの(page+1ページ目)が、filterに含まれていた場合
            
            i = 0 #0ならフィールド情報、1ならコメント情報
            for i in 1..2 do
                arr_sortfilter.push("") #まずはfilter並び替え配列に2つ要素をpush
                
            end
            
            
            arr_sortfilter[constructed_pages*2 + 0] = arr_unique_text[page]
            arr_sortfilter[constructed_pages*2 + 1] = $arr_unique_comment[page]
            
            constructed_pages += 1
            
        end
    end
    
    return arr_sortfilter
end


$arr_sortfilter = comparisonAndNewConstruction(page)
#p $arr_sortfilter

pagecnt = ($arr_sortfilter.size) / 2 #filter並び替え情報配列の要素数を2で割った商が、ページ数
page    = 0 #今いるページ







def encodeFieldText(page) #フィールドデータを文字列にエンコード
    curr_field_text = $arr_sortfilter[page * 2  +  0]  #今いるページのブロック番号文字列
    
    if page == 0 #前のページのブロック番号文字列ももってくる
        prev_field_text = "0"*240 #1ページ目なら、前はすべて空白(0が240個)
    else
        prev_field_text = $arr_sortfilter[(page - 1) * 2  +  0] #2ページ目以降なら、前のページをもってくる
    end
    
    #_encodeFieldText(curr_field_text, prev_field_text)
    _encodeFieldText(curr_field_text, "0"*240)
end


def _encodeFieldText(curr_field_text, prev_field_text) #フィールドデータを文字列にエンコード
    encoded_text = "" #エンコードが完了した文字を結合していく用

    prevdiff = 0 #前回のdiff値と今回のdiff値に分けることで、変化を検知しやすくする
    currdiff = curr_field_text[0].to_i - prev_field_text[0].to_i + 8 #先頭のdiff値で初期化する

    totalcnt = 0 #cntの合計、すなわちエンコードしたブロック数

    index = 1 #現在チェックしている位置を保存する用。先頭は初期値に含まれているので、その次のブロックから開始する

    while index < 240 do #240ブロックエンコードできるまでループ

        cnt = 0 #前回と今回のdiff値が同じである回数を数える用

        while index < 240 do #240ブロックエンコードできるまでループ

            curr = curr_field_text[index].to_i #今回調べる座標のブロック番号を数値化
            prev = prev_field_text[index].to_i #前回調べた座標のブロック番号を数値化

            prevdiff = currdiff #今回の座標を上書きする前に、前回の座標に値渡ししておく
            currdiff = curr - prev + 8

            index += 1

            if prevdiff != currdiff
                break
            else
                cnt += 1
            end
        end

        val = prevdiff * 240 + cnt
        encoded_text += formatNum(val, 2, 0)

        totalcnt += cnt

        if totalcnt >= 240
            break
        end

    end

    return encoded_text #エンコードが完了したら、できた文字列を関数外に返す
end




def encodeCommentText(page) #(コメントフラグと)コメントデータを文字列にエンコード
    
    comment_text = $arr_sortfilter[page * 2  +  1] #今いるページのコメント文字列
    encoded_text = "AgW"
    
    encoded_text += formatNum(comment_text.length, 2, 0) #文字数を記録する
    
    div, mod =getDivMod(comment_text.length, 4)
    #p div,mod
    
    if mod != 0
        div += 1
        comment_text += (" " * (4 - mod) ) #(4 - 文字数を4で割ったあまり)の数だけ、末尾を「 」でpaddingし、商を1増やす
    end
    
    
    i = 0
    
    for i in 1.. div do
        
        text = comment_text.slice!(0, 4)
        num = formatText(text, 1)
        encoded_text += formatNum(num, 5, 0)
        
    end
    
    return encoded_text
end




encoded_text = "" #エンコードされた文字列を結合する用

for page in 0..pagecnt - 1 do
    encoded_text += encodeFieldText(page)
    encoded_text += encodeCommentText(page)
end



def selectEncodeFormat(type, text) #出力形式に応じてURLの文字列を付け足す
    
    case type
        when 1 #1...通常
            plustext = "https://fumen.zui.jp/?v115@"
        when 2 #2...モバイル版
            plustext = "https://knewjade.github.io/fumen-for-mobile/#?d=v115@"
        when 3 #3...HardDrop版
            plustext = "https://harddrop.com/fumen/?v115@"
        when 4 #4...FullのList形式
            plustext = "https://fumen.zui.jp/?d115@"
        when 5 #5...MiniのList形式
            plustext = "https://fumen.zui.jp/?D115@"
        when 6 #6...View形式
            plustext = "https://fumen.zui.jp/?m115@"
        else #0...RAW DATA
            plustext = "v115@"
    end
    
    return plustext + text
    
end

puts ""
puts "結果URL"
puts "result URL"
puts selectEncodeFormat($arr_input_data[2], encoded_text)
puts ""

puts "URLをドラッグして選択し、Ctrl+Cキーでコピーしてください"
puts "Drag the URL to select it and press Ctrl + C to copy it."
puts "コピーできたら、なにもドラッグせずにCtrl+Cキーを押してプログラムを終了させてください"
puts "After copying, press Ctrl + C without dragging anything to exit the program."
while 1
    sleep 1
end
