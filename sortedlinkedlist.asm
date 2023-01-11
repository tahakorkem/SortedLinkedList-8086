        ; SIRALI LİNKLİ LİSTE
        ; -----------------------------------------------------------------------
        ; Okunan işaretli iki sayının toplamını hesaplayıp ekrana yazdırır.
        ; MAIN      : Ana yordam 
        ; PUTTITLE  : Başlığı ve bulunulan menünün ismini
        ;             yazdırır.
        ; ADDARR    : Kullanıcıdan alınan uzunlukta bir dizi girişini alır ve
        ;             bu diziyi linklerini oluşturarak ekler.
        ; LINKELM   : SI offsetinde bulunan -yani en son eklenen- elemanın
        ;             linkini oluşturur.
        ; DSPARR    : Dizinin tüm elemanlarını, adreslerini ve linkleri yazdırır.
        ; ADDELM    : Kullanıcıdan alınan bir değeri diziye ekler ve linkini
        ;             oluşturur.
        ; CLS       : Konsolu temizler.
        ; -----------ALTTAKİ YORDAMLAR DOĞRUDAN KİTAPTAN ALINMIŞTIR.------------
        ; PUT_STR   : Ekrana sonu 0 ile belirlenmiş dizgeyi yazdırır. 
        ; PUTC      : AL deki karakteri ekrana yazdırır. 
        ; GETC      : Klavyeden basılan karakteri AL’ye alır.
        ; PUTN      : AX’deki sayıyı ekrana yazdırır. 
        ; GETN      : Klavyeden okunan sayıyı AX’e koyar
        ; -----------------------------------------------------------------------
SSEG    SEGMENT PARA STACK 'STACK'
    DW 32 DUP (?)
SSEG    ENDS

DSEG    SEGMENT PARA 'DATA'
CR      EQU 13
LF      EQU 10
TB      EQU 9

SEPARATOR   DB CR, LF, '####################################################',0
PROG_TITLE  DB CR, LF, '################### Taha Korkem ####################',0
MMENU_MSG   DB CR, LF, '#################### ANA MENU ######################',0
SMENU1_MSG  DB CR, LF, '################## 1-DIZI GIRISI ###################',0
SMENU2_MSG  DB CR, LF, '################# 2-LINK LISTELEME #################',0
SMENU3_MSG  DB CR, LF, '################# 3-ELEMAN EKLEME ##################',0

NEW_LINE    DB CR, LF, 0
TAB         DB TB, 0
MENU_CH     DB CR, LF, '1 - Dizi girisi yapin', CR, LF, '2 - Linkleri gorunteleyin', CR, LF, '3 - Eleman ekleyin', CR, LF, '9 - Programdan cikmak istiyorum',0
SCANC_MSG   DB CR, LF, 'Seciminizi girin: ',0

SCANC_ERR   DB CR, LF, 'Gecerli bir secim girmediniz!',0

SCAN_ARRLEN_MSG DB CR, LF, 'Dizinin uzunlugunu girin: ',0
SCAN_NTH_ELM_MSG DB '. dizi elemanini girin: ',0
SCANL_ERR       DB CR, LF, 'Dizi uzunlugu 1 ile 100 arasinda olmalidir!',0
ADDARR_SCSS     DB CR, LF,'Dizi basariyla eklendi!',0

SCAN_ADD_ELM_MSG DB CR, LF, 'Eklemek istediginiz degeri girin: ',0
OVERL_ERR       DB CR, LF, "Dizi 100'den fazla eleman alamaz!",0
ADDELM_SCSS     DB CR, LF,'Eleman basariyla eklendi!',0

EMPTY_ARR_MSG   DB CR, LF, 'Dizi bos! Lutfen ilk once dizi girin ya da eleman ekleyin!',0
TABLE_SEP       DB '| ',0
TABLE_BOR       DB CR, LF, TB, TB, '+-------+-------+-------+',0
COLUMN_INFO     DB CR, LF, TB, TB, '| ADRES', TB, '| DEGER', TB, '| LINK', TB, '|',0
HEAD_INFO       DB ' BASLANGIC ->',0

SMENU_END_MSG   DB CR, LF, 'Ana menuye donmek icin bir tusa basin...',0

ERR     DB CR, LF, 'Gecerli bir sayi girmediniz! Tekrar giris yapiniz: ', 0

CHOICE  DW 0

HEAD    DW -1
ARR     DW 100 DUP(?)
LINKS   DW 100 DUP(?)
ARRLEN  DW 0

DSEG    ENDS 

CSEG    SEGMENT PARA 'CODE'
    ASSUME CS:CSEG, DS:DSEG, SS:SSEG
MAIN    PROC FAR
        ;------------------------------------------------------------------------
        ; Kullanıcıya 3 alt menü ve çıkış seçeneğinden oluşan 4 menü gösterilir.
        ; Kullanıcı geçerli bir sayı tuşladıysa o seçeneğe gidilir. Eğer geçersiz
        ; bir sayı tuşladıysa kullanıcıdan tekrar giriş alınır.
        ; Alt menülerde yapılan işlem bittiğinde ana menüye dönmek için
        ; kullanıcıdan giriş alınır.
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX, DSEG 
        MOV DS, AX
        
MENU:   CALL PUTTITLE                   ; menü başlığını yazdır
        
        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR                
        
        MOV AX, OFFSET MENU_CH          ; menü seçeneklerini
        CALL PUT_STR                    ; yazdır

        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR                
        
SCANC:  MOV AX, OFFSET SCANC_MSG        ; seçim okunma
        CALL PUT_STR                    ; mesajını yazdır
        
        CALL GETN                       ; kullanıcıdan alınan sayıyı
        MOV CHOICE, AX                  ; CHOICE değişkenine ata
        
        CMP CHOICE, 1                   ; CHOICE 1 ise
        JE C1                           ; C1 koluna dallan
        
        CMP CHOICE, 2                   ; CHOICE 2 ise
        JE C2                           ; C2 koluna dallan
        
        CMP CHOICE, 3                   ; CHOICE 3 ise
        JE C3                           ; C3 koluna dallan
        
        CMP CHOICE, 9                   ; CHOICE 9 ise
        JE END_PR                       ; END_PR koluna dallan
        
                                        ; CHOICE belirlenen değerlerden biri değilse
CNOT:   MOV AX, OFFSET SCANC_ERR        ; geçerli bir menü seçimi
        CALL PUT_STR                    ; yapılmadığı mesajını yazdır
        JMP SCANC                       ; tekrar okuma almak için SCANC koluna dallan
            
C1:     CALL ADDARR                     ; ADDARR yordamını çağır
        JMP E                           ; E koluna dallan
        
C2:     CALL DSPARR                     ; DSPARR yordamını çağır
        JMP E                           ; E koluna dallan
                
C3:     CALL ADDELM                     ; ADDELM yordamını çağır
        JMP E                           ; E koluna dallan
                    
E:      MOV AX, OFFSET NEW_LINE
        CALL PUT_STR                
        
        MOV AX, OFFSET SMENU_END_MSG    ; alt menünün sonuna gelindiği
        CALL PUT_STR                    ; mesajını yazdır
        
        CALL GETC                       ; ana menüye dönmek için kullanıdan giriş bekle

        MOV CHOICE, 0                   ; CHOICE değişkenini sıfırla
                                        ; ana menüde olduğunun anlaşılması için gerekli
        JE MENU                         ; başa dönmek için MENU koluna dallan
        
END_PR: RETF 
MAIN    ENDP

PUTTITLE PROC NEAR
        ;------------------------------------------------------------------------
        ; Başlığı ve CHOICE değişkenine göre bulunulan menüye
        ; dair mesajı yazdırır.
        ;------------------------------------------------------------------------
        PUSH AX
        
        CALL CLS                        ; ilk önce konsolu temizle
        
        MOV AX, OFFSET SEPARATOR        ; başa düz bir
        CALL PUT_STR                    ; '#' satırı yazdır
        
        MOV AX, OFFSET PROG_TITLE       ; program başlığını
        CALL PUT_STR                    ; yazdır
                
        CMP CHOICE, 0                   ; şu an ana menüdeysek
        JE S_MM                         ; S_MM koluna dallan
        
        CMP CHOICE, 1                   ; şu an 1. alt menüdeysek
        JE S_C1                         ; S_C1 koluna dallan
        
        CMP CHOICE, 2                   ; şu an 2. alt menüdeysek
        JE S_C2                         ; S_C2 koluna dallan
        
        CMP CHOICE, 3                   ; şu an 3. alt menüdeysek
        JE S_C3                         ; S_C3 koluna dallan    
        
        JMP CC
        
S_MM:   MOV AX, OFFSET MMENU_MSG        ; ana menü
        CALL PUT_STR                    ; mesajını yazdır
        JMP CC
        
S_C1:   MOV AX, OFFSET SMENU1_MSG       ; 1. alt menü
        CALL PUT_STR                    ; mesajını yazdır    
        JMP CC
        
S_C2:   MOV AX, OFFSET SMENU2_MSG       ; 2. alt menü
        CALL PUT_STR                    ; mesajını yazdır    
        JMP CC
        
S_C3:   MOV AX, OFFSET SMENU3_MSG       ; 3. alt menü
        CALL PUT_STR                    ; mesajını yazdır    
        JMP CC        
    
CC:     MOV AX, OFFSET SEPARATOR        ; sona düz bir
        CALL PUT_STR                    ; '#' satırı yazdır
        
        POP AX
        RET
PUTTITLE ENDP

ADDARR  PROC NEAR
        ;------------------------------------------------------------------------
        ; Kullanıcıdan dizi uzunluğu alınır. 100'den büyükse tekrar alınır. Aksi
        ; takdirde kullanıcıdan dizinin tüm elemanların girişi sırasıyla alınır.
        ; Alınan her bir değer ilk önce diziye eklenir. Sonra da o değer için
        ; link oluşturulur.
        ; SI: Dizinin iterasyonun şu anki adımındaki indisi
        ; DI: İterasyonun kaçıncı adımında olunduğu bilgisi 1,2,3.. şeklinde
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH CX
        PUSH SI
        PUSH DI
                    
        CALL PUTTITLE                   ; menü başlığını yazdır
        
        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR                

SCANARRLEN:
        MOV AX, OFFSET SCAN_ARRLEN_MSG  ; dizinin uzunluğunu okuma
        CALL PUT_STR                    ; mesajını yazdır
        
        CALL GETN                       ; kullanıcıdan alınan sayıyı
        MOV ARRLEN, AX                  ; ARRLEN değişkenine ata
        
        CMP ARRLEN, 100                 ; dizi uzunluğu 100'den büyükse
        JG INVINP                       ; INVINP koluna dallan
        
        CMP ARRLEN, 0                   ; dizi uzunluğu 0'dan küçük veya eşitse
        JLE INVINP                      ; INVINP koluna dallan

        JMP VALINP                      ; devam et
                                        
INVINP: MOV AX, OFFSET SCANL_ERR        ; dizi uzunluğu okuma hata
        CALL PUT_STR                    ; mesajını yazdır
        
        JMP SCANARRLEN                  ; kullanıcdan tekrar giriş almak için
                                        ; SCANARRLEN koluna dallan
VALINP:                
        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR
        
        MOV CX, ARRLEN                  ; CX'e dizi uzunluğunu ata, döngü sayısı olarak   
        MOV HEAD, -1                    ; HEAD değerini kaldır
                                        ; ilk dizi girişinden sonraki dizi girişleri için
        XOR SI, SI                      ; SI'yı sıfırla
        MOV DI, 1                       ; DI'ya 1 ata
        
ARR_LOOP:
        MOV AX, DI                      ; DI sayı değerini
        CALL PUTN                       ; yazdır
        
        MOV AX, OFFSET SCAN_NTH_ELM_MSG ; n. eleman okuma mesajını
        CALL PUT_STR                    ; yazdır

        CALL GETN                       ; kullanıcıdan alınan sayıyı
        MOV ARR[SI], AX                 ; diziye ekle
        CALL LINKELM                    ; eklenen değere link oluşturmak için
                                        ; LINKELM yordamını çağır
        ADD SI, 2                       ; SI değerini 2 artır, dizi elemanları WORD olduğu için
        INC DI                          ; DI değerini 1 artır

        LOOP ARR_LOOP                   ; döngü başına CX'i bir azaltarak dön
        
        MOV AX, OFFSET ADDARR_SCSS      ; sonuç mesajını
        CALL PUT_STR                    ; yazdır
        
        POP DI
        POP SI
        POP CX
        POP AX
        RET
ADDARR  ENDP

LINKELM PROC NEAR
        ;------------------------------------------------------------------------
        ; Dizinin SI indisinde bulunan yeni eleman için link oluşturulur.
        ; Linkli listenin HEAD'inden başlanarak elemanlar arası gezinilir.
        ; Her elemanın linki kullanılarak diğer elemana ulaşılır, -1'e gelene kadar.
        ; Hiç eleman yoksa veya yeni eleman ilk elemandan büyükse,
        ; yeni eleman HEAD değişkenine atanır. Aksi takdirde yeni eleman
        ; kendisinden küçük bir elemana denk gelene dek döngü sürer.
        ; Kendisinden küçük bir elemana denk gelmez de son gezilen elemanın
        ; linki -1 olursa da döngüden çıkılır.
        ; AX: Yeni eklenen eleman
        ; CX: Linkli listenin iterasyondaki değeri
        ; BX: Linkli listenin bir önceki değerinin indisi
        ; DI: Linkli listenin şu anki değerinin indisi
        ;------------------------------------------------------------------------
        PUSH DI
        PUSH AX
        PUSH BX
        PUSH CX

        MOV BX, -1                      ; BX'e -1 ata
        
        MOV AX, ARR[SI]                 ; AX'e dizinin yeni eklenen elemanını al
        
        MOV DI, HEAD                    ; DI'ya ilk olarak HEAD'i ata
        
        CMP DI, -1                      ; DI -1'e eşitse yani dizide hiç eleman yoksa
        JE UPD_HEAD                     ; UPD_HEAD koluna dallan
                                
        CMP AX, ARR[DI]                 ; AX, linkli listenin ilk elemanından
        JLE UPD_HEAD                    ; küçük veya eşitse UPD_HEAD koluna dallan
        
LINK_LOOP:
        MOV CX, ARR[DI]                 ; CX'e dizinin şu anki indisindeki eleman atanır
        
        CMP AX, CX                      ; AX, şu anki elemandan küçük veya eşitse
        JLE END_LP                      ; döngüden çık

        MOV BX, DI                      ; bir önceki DI değerini BX'e al
        MOV DI, LINKS[DI]               ; link değerini DI'ya al
        
        CMP DI, -1                      ; DI, -1 ise yani linkli listenin son elemanı da
                                        ; okunduysa
        JE END_LP                       ; döngüden çık
        
        JMP LINK_LOOP                   ; döngüye devam et
        
UPD_HEAD:
        MOV HEAD, SI                    ; HEAD değişkenine SI değerini ata
                                        ; yani yeni elemanı HEAD yap
        JMP ASG_LN                      ; önceki değere link atamasını es geç
                                
END_LP: MOV LINKS[BX], SI               ; önceki indisteki linki, yeni elemanı
                                        ; gösterecek şekilde güncelle    
ASG_LN: MOV LINKS[SI], DI               ; yeni elemanın linkini DI yap

            
END_P:        
        POP CX
        POP BX
        POP AX
        POP DI        
        RET
LINKELM ENDP

DSPARR  PROC NEAR
        ;------------------------------------------------------------------------
        ; Dizide hiç eleman yoksa dizinin boş olduğu bilgisi yazdırılır.
        ; Dizide eleman varsa dizinin indisleri, değerleri, linkleri
        ; tablo şeklinde yazdırılır.
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH CX
        PUSH SI
        PUSH DI
        
        CALL PUTTITLE                   ; menü başlığını yazdır
        
        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR
        
        CMP ARRLEN, 0                   ; dizi uzunluğu 0 ise EMPTYARR koluna
        JNE CONT                        ; 0 değilse CONT koluna dallan
        
EMPTYARR:
        
        MOV AX, OFFSET EMPTY_ARR_MSG    ; dizinin boş olduğu 
        CALL PUT_STR                    ; mesajını yazdır

        JMP EXIT_D                      ; dizi boşsa EXIT koluna git
                                        ; yani yordamı terk et
    
CONT:   MOV AX, OFFSET TABLE_BOR        ; tablonun en üstüne
        CALL PUT_STR                    ; çizgi yazdır
        
        MOV AX, OFFSET COLUMN_INFO      ; tablonun sütun bilgilerini
        CALL PUT_STR                    ; yazdır
        
        MOV AX, OFFSET TABLE_BOR        ; sütun bilgisi altına
        CALL PUT_STR                    ; çizgi yazdır
                
        MOV CX, ARRLEN                  ; CX=ARRLEN, dizi uzunluğu iterasyon içeren döngü başlatılacak
        XOR DI, DI                      ; DI'yı sıfırla, DI iterasyondaki indis olarak kullanılacak
                
TABLE_LOOP:
        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR

        CMP HEAD, DI                    ; dizinin şu anki elemanı 
        JNE NONHROW                     ; HEAD in gösterdiği eleman ise HEADROW koluna
                                        ; değilse NONHROW koluna dallan
HEADROW:
        MOV AX, OFFSET HEAD_INFO        ; satırın soluna
        CALL PUT_STR                    ; ' BAŞLANGIÇ ->' yazdır
        JMP A                           ; A koluna dallan, fazladan TAB yazdırmayı önler
NONHROW:        
        MOV AX, OFFSET TAB
        CALL PUT_STR

A:      MOV AX, OFFSET TAB
        CALL PUT_STR

        MOV AX, OFFSET TABLE_SEP        ; tablo satırının başına
        CALL PUT_STR                    ; '| ' yazdır

        MOV AX, DI                      ; dizinin şu anki iterasyondaki
        CALL PUTN                       ; indisini/adresini yazdır
        
        MOV AX, OFFSET TAB
        CALL PUT_STR

        MOV AX, OFFSET TABLE_SEP        ; satırın sütunlarının arasına
        CALL PUT_STR                    ; '| ' yazdır

        MOV AX, ARR[DI]                 ; dizinin iterasyondaki indisindeki
        CALL PUTN                       ; elemanını yazdır
        
        MOV AX, OFFSET TAB
        CALL PUT_STR
        
        MOV AX, OFFSET TABLE_SEP        ; satırın sütunlarının arasına
        CALL PUT_STR                    ; '| ' yazdır

        MOV AX, LINKS[DI]               ; iterasyondaki elemanın
        CALL PUTN                       ; linkini yazdır
        
        MOV AX, OFFSET TAB
        CALL PUT_STR
        
        MOV AX, OFFSET TABLE_SEP        ; tablo satırının sonuna
        CALL PUT_STR                    ; '| ' yazdır
        
        ADD DI, 2                       ; DI iki artırılır, dizi elemanları WORD olduğu için
        LOOP TABLE_LOOP                 ; döngü başına CX'i bir azaltarak dön
        
        MOV AX, OFFSET TABLE_BOR        ; tablonun en altına
        CALL PUT_STR                    ; çizgi yazdır
        
EXIT_D: POP DI
        POP SI
        POP CX
        POP AX
        RET
DSPARR  ENDP

ADDELM  PROC NEAR
        ;------------------------------------------------------------------------
        ; Dizinin uzunluğunun iki katınıncı indisine kullanıcıdan alınan değer
        ; atanır. Dizi uzunluğu bir artırılır.
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH SI
        
        CALL PUTTITLE                   ; menü başlığını yazdır
                
        MOV AX, OFFSET NEW_LINE
        CALL PUT_STR
        
        CMP ARRLEN, 100                 ; dizi uzunluğu 100'den küçükse
        JL D                            ; devam et
        
        MOV AX, OFFSET OVERL_ERR        ; dizi uzunluğu 100'den fazlaysa
        CALL PUT_STR                    ; uyarı mesajını yazdır
        JMP EXIT_A                      ; yordamın çıkışına git
        
D:      MOV SI, ARRLEN                  ; dizi uzunluğunu SI yazmaçına al
        SHL SI, 1                       ; dizi uzunluğunun iki katını al
        
        MOV AX, OFFSET SCAN_ADD_ELM_MSG ; yeni eleman ekleme
        CALL PUT_STR                    ; okuma mesajını yazdır

        CALL GETN                       ; kullanıcıdan alınan sayı  
        MOV ARR[SI], AX                 ; diziye eklenir
        CALL LINKELM                    ; eklenen eleman linklenir
        INC ARRLEN                      ; dizi uzunluğu bir artırılır
        
        MOV AX, OFFSET ADDELM_SCSS      ; sonuç mesajını
        CALL PUT_STR                    ; yazdır

EXIT_A: POP SI
        POP AX
        RET
ADDELM  ENDP

CLS     PROC NEAR
        ;------------------------------------------------------------------------
        ; Konsolda yazılanlar temizlenir.
        ;------------------------------------------------------------------------
        PUSH AX
        MOV AX, 03h
        INT 10h
        POP AX
        RET
CLS     ENDP

; ----------------------------------------------------------------------
; -----------ALTTAKİ YORDAMLAR DOĞRUDAN KİTAPTAN ALINMIŞTIR.------------
; ----------------------------------------------------------------------

GETC    PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan karakteri AL yazmacına alır ve ekranda gösterir. 
        ; işlem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC    ENDP 

PUTC    PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC    ENDP 

GETN    PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan sayiyi okur, sonucu AX yazmacı üzerinden dondurur. 
        ; DX: sayının işaretli olup/olmadığını belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan sayının islenmesi sırasındaki ara değeri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten dönüş değeri olarak değişmek durumundadır. Ancak diğer 
        ; yazmaçların önceki değerleri korunmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1                       ; sayının şimdilik + olduğunu varsayalım 
        XOR BX, BX                      ; okuma yapmadı Hane 0 olur. 
        XOR CX,CX                       ; ara toplam değeri de 0’dır. 
NEW:
        CALL GETC                       ; klavyeden ilk değeri AL’ye oku. 
        CMP AL,CR 
        JE FIN_READ                     ; Enter tuşuna basilmiş ise okuma biter
        CMP  AL, '-'                    ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM                   ; gelen 0-9 arasında bir sayı mı?
NEGATIVE:
        MOV DX, -1                      ; - basıldı ise sayı negatif, DX=-1 olur
        JMP NEW                         ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'                     ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error                        ; değil ise HATA mesajı verilecek
        SUB AL,'0'                      ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL                      ; BL’ye okunan haneyi koy 
        MOV AX, 10                      ; Haneyi eklerken *10 yapılacak 
        PUSH DX                         ; MUL komutu DX’i bozar işaret için saklanmalı
        MUL CX                          ; DX:AX = AX * CX
        POP DX                          ; işareti geri al 
        MOV CX, AX                      ; CX deki ara değer *10 yapıldı 
        ADD CX, BX                      ; okunan haneyi ara değere ekle 
        JMP NEW                         ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET ERR 
        CALL PUT_STR                    ; HATA mesajını göster 
        JMP GETN_START                  ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX                      ; sonuç AX üzerinden dönecek 
        CMP DX, 1                       ; İşarete göre sayıyı ayarlamak lazım 
        JE FIN_GETN
        NEG AX                          ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN    ENDP 

PUTN    PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX     
        XOR DX, DX                      ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX                         ; haneleri ASCII karakter olarak yığında saklayacağız.
                                        ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                        ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10                      ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS    
        NEG AX                          ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX                         ; AX sakla 
        MOV AL, '-'                     ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX                          ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX                          ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'                     ; kalan değerini ASCII olarak bul 
        PUSH DX                         ; yığına sakla 
        XOR DX,DX                       ; DX = 0
        CMP AX, 0                       ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS                 ; işlemi tekrarla 
        
DISP_LOOP:
                                        ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                        ; en az anlamlı hane en alta ve onu altında da 
                                        ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX                          ; sırayla değerleri yığından alalım
        CMP AX, 0                       ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC                       ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                   ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN    ENDP 

PUT_STR PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX 
        MOV BX, AX                      ; Adresi BX’e al 
        MOV AL, BYTE PTR [BX]           ; AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL, 0        
        JE  PUT_FIN                     ; 0 geldi ise dizge sona erdi demek
        CALL PUTC                       ; AL’deki karakteri ekrana yazar
        INC BX                          ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP                    ; yazdırmaya devam 
PUT_FIN:
        POP BX
        RET 
PUT_STR ENDP

CSEG    ENDS 
    END MAIN
