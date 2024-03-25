# 4d-topic-export-xlsx
Zipコマンドで.xlsxファイルをエクスポートするには

* xlsxはzipファイルである
* Microsoft Excelでテンプレートを作成する
* 標準zipコマンドでxlsxを開いて閉じる
* XLSXクラス
* 標準xmlコマンドでxlsxの内容を更新する
* 日付・ブール・文字列の書き込み
* 数式の書き込み
* ループ処理でデータのエクスポート

# エラーを避けるために工夫したこと

* Excelは，最後に計算したセルの情報を`xl/calcChain.xml`に持っており，必要に応じて内容を更新している。計算セルを追加した場合は良いが，削除した場合，`xl/calcChain.xml`に無効なセル参照が残ってしまい，エラーになる可能性がある。あるいはエラーにならない場合，間違った値が画面に表示される可能性がある。xmlコマンドで直接スプレッドシートを更新する場合，`xl/calcChain.xml`を削除するのが無難。なければExcelが自動的に再計算を実行する。

* スプレッドシートには，計算セル（`<f>`）と一緒に計算値（`<v>`）も書き込まれており，プレビューソフトなどは，一般的に後者をそのまま出力する。Excelも スプレッドシートを開いた直後にすべてのセルを再計算することはしないが，`xl/workbook.xml`の`/workbook/calcPr@fullCalcOnLoad`が`1`にセットされていると，開いた直後にすべてのセルを再計算する。xmlコマンドで直接スプレッドシートを更新した場合，`fullCalcOnLoad`を`1`に設定するのが無難。

* 列数はテンプレートのほうで用意すること（`1`行でも当該列に値が設定されていれば良い）
