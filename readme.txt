### 目的
　テンプレートからIDのみ変更したクエリを自動生成する。

### 手順
　1. 「Template」フォルダ内にテンプレートのクエリを配置する。
　2. 「def.ini」に置換対象文字列と置換後の文字列をカンマ区切りで記載する。（複数行可能）
　3. 「exec.rb」を実行する。
　4. 「Out」フォルダ内に文字列が置換されたクエリが生成される。

### 動作検証環境
　Ruby:2.4.0
　OS　:Mac OS X El Capitan

