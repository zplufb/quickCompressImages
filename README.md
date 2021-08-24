# quickCompressImages

基于ImageMagick，批量（当前文件夹及子文件夹）处理图片压缩方法

## 快速压缩图片方法（小白篇）

## 0 适用场景

批量上传图片到云服务器（例如七牛云），但不需要用这么高清的图片。

例如发文章在得物，小红书等平台时。

## 1 前提

- 操作系统：windows 64位
- ImageMagick版本：v7
  - 下载地址（官方）：https://imagemagick.org/script/download.php 选择Windows Binary Release
    - 具体地址：https://download.imagemagick.org/ImageMagick/download/binaries/ImageMagick-7.1.0-5-Q16-HDRI-x64-dll.exe
  - 下载地址：https://fanbi.xyz:9911/share/software/ImageMagick-7.0.10-11-Q16-x64-dll.exe
- 安装bash环境，可以直接下载git安装包含bash环境
  - 下载地址（官网）：[Git (git-scm.com)](https://git-scm.com/)
  - 下载地址2：[【Git下载】2021年最新官方正式版Git免费下载 - 腾讯软件中心官网 (qq.com)](https://pc.qq.com/detail/13/detail_22693.html)
- 注意事项：脚本文件名不能是中文

## 2 脚本

### 2.1 核心代码

~~~sh
#批量把当前目录的jpg图片 分辨率下降至25%，质量下降一半成像
#假定文件名：batchCompressImagesIncludeSubFiles5050.sh
magick *.jpg -resize 50% -quality 50 op_%03d.jpg
~~~

### 2.2 批量处理

说明：批量处理指定文件夹及子文件夹所有图片

#### 2.2.1 带参数

指定目录及分辨率及质量三个参数

文件名：batchCompressImagesIncludeSubFilesWithParams.sh

~~~sh
#!/bin/bash
read_dir(){
    echo 'start walk through dir of'$1
	suffixJpg='.jpg'
	suffixJpeg='.jpeg'
	suffixPng='.png'
	for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                read_dir $1"/"$file
            fi
        else
            echo $1"/"$file
            if [[ ${file:0-4:4} == ${suffixJpg} ||  ${file:0-5:5} == ${suffixJpeg} ]]
            then
				magick  $1"/"$file -resize $2% -quality $3%  $1"/"op_$file
			fi
			if [[ ${file:0-4:4} == ${suffixPng} ]]
            then
				magick  $1"/"$file -resize $2% -quality $3%  $1"/"op_$file.jpg
			fi
        fi
    done
    echo 'walk complete for dir of'$1
}
read_dir $1 $2 $3
~~~

#### 2.2.1 简化版

指定目录

文件名：batchCompressImagesIncludeSubFiles5050.sh

~~~sh
#!/bin/bash
read_dir(){
	suffixJpg='.jpg'
	suffixJpeg='.jpeg'
	suffixPng='.png'
	for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                read_dir $1"/"$file
            fi
        else
            echo $1"/"$file
            if [[ ${file:0-4:4} == ${suffixJpg} ||  ${file:0-5:5} == ${suffixJpeg} ]]
            then
				magick  $1"/"$file -resize 50% -quality 50  $1"/"op_$file
			fi
			if [[ ${file:0-4:4} == ${suffixPng} ]]
            then
				magick  $1"/"$file -resize 50% -quality 50  $1"/"op_$file.jpg
			fi
        fi
    done
}
read_dir $1
~~~

文件名：runCompressSubFiles.sh

```sh
#.代表当前所在目录
batchCompressImagesIncludeSubFiles5050.sh .
```

## 3 使用及效果

### 3.1 使用样例

1. 打开git bash
2. 输入runCompressSubFiles onedir
3. 回车

### 3.2 效果

压缩后的图片和原图，眼睛上看差别几乎没有（由于现在手机拍照像素高，拍出来5M起）。

| 文件名   | 原图大小 | 压缩后大小 | 压缩率 |
| -------- | -------- | ---------- | ------ |
| four.jpg | 9282 KB  | 307 KB     | 3.31%  |
| one.jpg  | 6433 KB  | 364 KB     | 5.66%  |
| two.png  | 24846 KB | 739 KB     | 2.97%  |



