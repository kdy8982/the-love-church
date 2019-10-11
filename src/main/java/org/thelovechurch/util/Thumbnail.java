package org.thelovechurch.util;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;

public class Thumbnail {
    public static void main(String args[]){
        try {
            //썸네일 가로사이즈
            int thumbnail_width = 100;
            //썸네일 세로사이즈
            int thumbnail_height = 100;
            //원본이미지파일의 경로+파일명
            File origin_file_name = new File("D:"+File.separator+"original_image.jpg");
            //생성할 썸네일파일의 경로+썸네일파일명
            File thumb_file_name = new File("D:"+File.separator+"thumbnail_image.jpg");
 
            BufferedImage buffer_original_image = ImageIO.read(origin_file_name);
            BufferedImage buffer_thumbnail_image = new BufferedImage(thumbnail_width, thumbnail_height, BufferedImage.TYPE_3BYTE_BGR);
            Graphics2D graphic = buffer_thumbnail_image.createGraphics();
            graphic.drawImage(buffer_original_image, 0, 0, thumbnail_width, thumbnail_height, null);
            ImageIO.write(buffer_thumbnail_image, "jpg", thumb_file_name);
            System.out.println("썸네일 생성완료");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
