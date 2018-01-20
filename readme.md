# NOAA Wind data to g0v airmap layer

## g0v airmap 風力圖層資料產生工具

產生流程如下:

- 抓取 [NOAA](http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl) 的風力資料

- 使用 [cambecc/grib2json](https://github.com/cambecc/grib2json) 將原始檔轉換成JSON檔案

- 使用 [fkei/JSON.minify](https://github.com/fkei/JSON.minify) 減少JSON體積 (選用)

- 使用 [Esri/wind-js](https://github.com/Esri/wind-js) 讀取風力JSON檔，繪製風力線條 (此專案未包含)

## 系統需求

- Ubuntu 16.04 x64

- JAVA JDK

- node.js


## cron script - gfs.sh
為了有效率處理，使用shll script完成整個流程，並直接發布到Git上

### 變數設定做解釋
- BASE_DIR: 專案檔案根目錄，即為本專案根目錄 (必要設定)
- SOURCE_JSON: grib2json 轉換後的 JSON 檔名
- DEST_DIR: 壓縮後輸出的JSON檔案位置 (必要設定)
- DEST_JSON: 輸出JSON檔案名稱

### Cron 設定

台灣時間

``` 30 5,11,17,23 * * * {path}/gfs.sh >> {log path}/gfs.log ```

UTC

``` 30 3,9,15,21 * * * {path}/gfs.sh >> {log path}/gfs.log ```

## jsonMinify

使用方法

``` node jsonMinify/index.js {source json path} {dest json path} ```

第一次使用請在 jsonMinify 下執行 npm install