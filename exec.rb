require "fileutils"

# 置換文字列クラス
class ReplaceText
  attr_accessor :replacement_str_array
  def initialize
    @replacement_str_array = Array.new()
  end
  def get_replace_text 
    begin
      File.open('def.ini') do |file|
        file.each_line do |labmen|
          # 置換対象の行のみ抽出する
          str = labmen.match(/^bind\d+=(.+),(.+)/)
          if !str.nil? then
            # 置換対象の文字列を受け取り、置換文字列を保持
            @replacement_str_array.push(str[1].to_s + "," + str[2].to_s)
          end
        end
      end
    rescue SystemCallError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    rescue IOError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    end
  end
end

# ファイルの文字列を置換するクラス
class ReplaceFile
  attr_accessor :replace_target_file, :replacement
  def initialize
    @replace_target_file = Array.new()
  end

  def get_replace_file
    Dir.glob("Out/*").each { |f|
      @replace_target_file.push(f)
    }
  end

  def set_replacement(text)
    @replacement = nil
    @replacement = text
  end

  def replace_files
    @replace_target_file.each { |l| exec(l) }
  end

  private
  def exec(path)
    # 読み取り専用でファイルを開き、内容をバッファに格納
    buffer = File.open(path, "r") { |f| f.read() }
    # バッファの中身を置換
    buffer.gsub!(@replacement.split(",")[0],@replacement.split(",")[1])
    # バッファを元のファイルに書き込む
    File.open(path, "w") { |f| f.write(buffer) }
  end
end

# 処理を実行するコントローラークラス
class TextReplace
 class << self
  def duplication_query
    FileUtils.cp_r(Dir.glob('Template/*.*'), "Out/")
  end
  def run
    # templateフォルダからoutフォルダにファイルをコピー
    self.duplication_query
    
    # 置換対象文字列を取得
    text = ReplaceText.new()
    text.get_replace_text
   
    # 置換対象のファイルを取得
    replacefile = ReplaceFile.new()
    replacefile.get_replace_file

    # ファイルを置換
    text.replacement_str_array.each_with_index { |s,i| 
      puts "-------------#{i + 1}番目の変換-------------"
      puts "置換対象文字列#{s}"
      replacefile.set_replacement(s)
      replacefile.replace_files
      puts "完了！"
    }
  end
 end
end

if __FILE__ == $0
  TextReplace.run
end
