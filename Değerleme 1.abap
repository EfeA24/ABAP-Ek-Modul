REPORT Zdegerleme1.


TYPES: BEGIN OF ty_hesap,
         hesap_numarasi TYPE string,
         hesap_adi      TYPE string,
         bakiye         TYPE p DECIMALS 2,
       END OF ty_hesap.



DATA: gt_hesaplar TYPE TABLE OF ty_hesap,
      gs_hesap  TYPE ty_hesap,
      gv_secim   TYPE i,
      gv_tutar   TYPE p DECIMALS 2.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_hesap_numarasi TYPE string OBLIGATORY,
            p_hesap_adi   TYPE string OBLIGATORY,
            p_bakiye       TYPE p DECIMALS 2.
SELECTION-SCREEN END OF BLOCK b1.


START-OF-SELECTION.

  PERFORM menu_goster.
  PERFORM secimi_isle.


FORM menu_goster.
  WRITE: / 'Finansal Modül Menüsü:',
         / '1. Hesap Oluştur',
         / '2. Bakiye Güncelle',
         / '3. Bakiye Sorgula',
         / '4. Çıkış',
         / 'Lütfen seçiminizi girin (1-4):'.
  READ gv_secim.
ENDFORM.

FORM secimi_isle.
  CASE gv_secim.
    WHEN 1.
      PERFORM hesap_olustur.
    WHEN 2.
      PERFORM bakiye_guncelle.
    WHEN 3.
      PERFORM bakiye_sorgula.
    WHEN 4.
      EXIT.
    WHEN OTHERS.
      WRITE: / 'Geçersiz seçim! Lütfen geçerli bir seçenek girin (1-4).'.
  ENDCASE.
ENDFORM.

FORM hesap_olustur.
  CLEAR gs_hesap.
  gs_hesap-hesap_numarasi = p_hesap_numarasi.
  gs_hesap-hesap_adi = p_hesap_adi.
  gs_hesap-bakiye = p_bakiye.
  APPEND gs_hesap TO gt_hesaplar.
  WRITE: / 'Hesap başarıyla oluşturuldu!'.
ENDFORM.

FORM bakiye_guncelle.
  SELECT SINGLE * FROM gt_hesaplar INTO gs_hesap
    WHERE hesap_numarasi = p_hesap_numarasi.
  IF sy-subrc = 0.
    WRITE: / 'Hesap', p_hesap_numarasi, 'için mevcut bakiye:', gs_hesap-bakiye,
           / 'Yatırılacak veya çekilecek tutarı girin:',
           / '(Çekim için negatif değer kullanın)'.
    READ gv_tutar.
    gs_hesap-bakiye = gs_hesap-bakiye + gv_tutar.
    MODIFY gt_hesaplar FROM gs_hesap.
    WRITE: / 'Bakiye başarıyla güncellendi!'.
  ELSE.
    WRITE: / 'Hesap bulunamadı!'.
  ENDIF.
ENDFORM.

FORM bakiye_sorgula.
  SELECT SINGLE * FROM gt_hesaplar INTO gs_hesap
    WHERE hesap_numarasi = p_hesap_numarasi.
  IF sy-subrc = 0.
    WRITE: / 'Hesap', p_hesap_numarasi, 'için mevcut bakiye:', gs_hesap-bakiye.
  ELSE.
    WRITE: / 'Hesap bulunamadı!'.
  ENDIF.
ENDFORM.