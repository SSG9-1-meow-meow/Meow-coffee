package com.ssg.meowcoffee.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

@Service
public class QrCodeService {

    /**
     * 주어진 텍스트(URL)를 QR 코드 이미지(PNG)의 byte 배열로 변환합니다.
     *
     * @param text QR 코드에 담을 텍스트
     * @param width QR 코드 이미지 너비
     * @param height QR 코드 이미지 높이
     * @return PNG 이미지 데이터 byte 배열
     */
    public byte[] generateQrCodeImage(String text, int width, int height) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        // 텍스트를 QR 코드 비트맵(BitMatrix)으로 인코딩
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);

        // BitMatrix를 PNG 이미지로 변환하기 위한 스트림
        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();

        // 스트림에 PNG 이미지 데이터를 씀
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);

        // 스트림의 내용을 byte 배열로 변환하여 반환
        return pngOutputStream.toByteArray();
    }
}
