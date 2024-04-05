----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"Assignment 3.1
"Structures and Internal Tables
"Create a report (z30923_xxxx_CurrConvert) for converting an amount from one currency to another currency.
"It should be possible to enter the source currency, the target currency and specify the amount.
"To manage the conversion rates between different currencies, create your own structured data type gty_currency_conversion (→ TYPES) that has the following fields
"• from_currency: short original currency, character(3), Example „EUR“
"• to_currency: short target currency, character(3), Example “AUD“
"• from_name: name original currency, character(20), Example “Euro“
"• to_name: name target currency, character(20), “Australian Dollar”
"• rate: conversion rate, p decimals 4

"To avoid redundancy in your code, define additional data types and variables, if needed. The following conversion data sets should be saved in an internal table that
"will be initialized with the data at program start.
"Original Currency  Short     Target Currency       Short    Conversion rate
"      Euro          EUR      Australian Dollar      AUD        1.55
"      Euro          EUR        Canadian Dollar      CAD        1.35
"    Swiss Francs    CHF            Euro             EUR        1.01
"Once the data has been entered on a selection screen the table will be searched for a suitable conversion rate. If a conversion rate is found the converted amount is 
"formatted and printed on the screen (as on the screenshot). If the conversion rate is not available an error message should be displayed on the screen.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass3_1.

* Input parameters
PARAMETERS: so_curr TYPE c LENGTH 3,
            tar_curr TYPE c LENGTH 3,
            amount  TYPE p .

* Define structured data type for currency conversion
TYPES: BEGIN OF gty_currency_conversion,
         from_currency TYPE c LENGTH 3,
         to_currency   TYPE c LENGTH 3,
         from_name     TYPE c LENGTH 20,
         to_name       TYPE c LENGTH 20,
         rate          TYPE p DECIMALS 4,
       END OF gty_currency_conversion.

* Internal table to store currency conversion data
DATA: it_currency_conversion TYPE TABLE OF gty_currency_conversion,
      wa_currency_conversion TYPE gty_currency_conversion.

* Initialize internal table with conversion data
wa_currency_conversion-from_currency = 'EUR'.
wa_currency_conversion-to_currency = 'AUD'.
wa_currency_conversion-from_name = 'Euro'.
wa_currency_conversion-to_name = 'Australian Dollar'.
wa_currency_conversion-rate = '1.55'.
APPEND wa_currency_conversion TO it_currency_conversion.

wa_currency_conversion-from_currency = 'EUR'.
wa_currency_conversion-to_currency = 'CAD'.
wa_currency_conversion-from_name = 'Euro'.
wa_currency_conversion-to_name = 'Canadian Dollar'.
wa_currency_conversion-rate = '1.35'.
APPEND wa_currency_conversion TO it_currency_conversion.

wa_currency_conversion-from_currency = 'CHF'.
wa_currency_conversion-to_currency = 'EUR'.
wa_currency_conversion-from_name = 'Swiss Francs'.
wa_currency_conversion-to_name = 'Euro'.
wa_currency_conversion-rate = '1.01'.
APPEND wa_currency_conversion TO it_currency_conversion.

* Converted amount
DATA: converted_amount TYPE p LENGTH 15 ,
      conversion_found TYPE abap_bool.

* Find the conversion rate
LOOP AT it_currency_conversion INTO wa_currency_conversion
     WHERE from_currency = so_curr
       AND to_currency = tar_curr.

  IF sy-subrc = 0.
    converted_amount = amount * wa_currency_conversion-rate.
    conversion_found = abap_true.
    EXIT.
  ENDIF.

ENDLOOP.

* Display the result or error message
IF conversion_found = abap_true.
  WRITE: / 'Source Currency:', so_curr,
          / 'Target Currency:', tar_curr,
          / 'Amount:', amount,
          / 'Converted Amount:',converted_amount ,
          / 'Conversion Rate:', wa_currency_conversion-rate,
          / 'From:', wa_currency_conversion-from_name,
          / 'To:', wa_currency_conversion-to_name.
ELSE.
  MESSAGE 'Conversion rate not found for the specified currencies.' TYPE 'E'.
ENDIF.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"Assignment 3.2.
"Data Dictionary
"Copy the report from the previous assignment (z30923_xxxx_CurrConvert) into a new report (z30923_xxxx_CurrConvertDD). Replace the local type definitions with definitions in 
"the Data Dictionary. Then, implement a new structure and the associated data elements and domains (also here: mind the naming convention e.g., z30923701Currency).

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass3_1.

* Input parameters
PARAMETERS: so_curr TYPE c LENGTH 3,
            tar_curr TYPE c LENGTH 3,
            amount  TYPE p .

* Define structured data type for currency conversion

 TYPES  gty_currency_conversion TYPE TABLE OF Z30923712_CURRENCY .

* Internal table to store currency conversion data
DATA: it_currency_conversion TYPE TABLE OF Z30923712_CURRENCY,
      wa_currency_conversion TYPE Z30923712_CURRENCY.


* Initialize internal table with conversion data
wa_currency_conversion-from_currency = 'EUR'.
wa_currency_conversion-to_currency = 'AUD'.
wa_currency_conversion-from_name = 'Euro'.
wa_currency_conversion-to_name = 'Australian Dollar'.
wa_currency_conversion-rate = '1.55'.
APPEND wa_currency_conversion TO it_currency_conversion.

wa_currency_conversion-from_currency = 'EUR'.
wa_currency_conversion-to_currency = 'CAD'.
wa_currency_conversion-from_name = 'Euro'.
wa_currency_conversion-to_name = 'Canadian Dollar'.
wa_currency_conversion-rate = '1.35'.
APPEND wa_currency_conversion TO it_currency_conversion.

wa_currency_conversion-from_currency = 'CHF'.
wa_currency_conversion-to_currency = 'EUR'.
wa_currency_conversion-from_name = 'Swiss Francs'.
wa_currency_conversion-to_name = 'Euro'.
wa_currency_conversion-rate = '1.01'.
APPEND wa_currency_conversion TO it_currency_conversion.

* Converted amount
DATA: converted_amount TYPE p LENGTH 15 ,
      conversion_found TYPE abap_bool.

* Find the conversion rate
LOOP AT it_currency_conversion INTO wa_currency_conversion
     WHERE from_currency = so_curr
       AND to_currency = tar_curr.

  IF sy-subrc = 0.
    converted_amount = amount * wa_currency_conversion-rate.
    conversion_found = abap_true.
    EXIT.
  ENDIF.

ENDLOOP.

* Display the result or error message
IF conversion_found = abap_true.
  WRITE: / 'Source Currency:', so_curr,
          / 'Target Currency:', tar_curr,
          / 'Amount:', amount,
          / 'Converted Amount:',converted_amount ,
          / 'Conversion Rate:', wa_currency_conversion-rate,
          / 'From:', wa_currency_conversion-from_name,
          / 'To:', wa_currency_conversion-to_name.
ELSE.
  MESSAGE 'Conversion rate not found for the specified currencies.' TYPE 'E'.
ENDIF.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 3.3.
"Database Tables
"Copy your program from the previous assignment (z30923_xxxx_CurrConvertDD) into a new report and change the code as follows: Instead of the conversion rates hard coded in the 
"report use conversion rates from the database table TCURR. The necessary descriptions for the currencies are stored in table TCURT (-> SELECT).


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT Z30923_712_ASS3_3.


* Input parameters
PARAMETERS: so_curr TYPE tcurr-fcurr,
            tar_curr TYPE tcurr-tcurr,
            amount  TYPE p .

* Define structured data type for currency conversion

 TYPES  gty_currency_conversion TYPE TABLE OF Z30923712_CURRENCY .

* Internal table to store currency conversion data
DATA: it_currency_conversion TYPE TABLE OF tcurr,
      wa_currency_conversion TYPE tcurr.


* Converted amount
DATA: converted_amount TYPE p LENGTH 15 ,
      conversion_found TYPE abap_bool.

* Find the conversion rate
LOOP AT it_currency_conversion INTO wa_currency_conversion
     WHERE fcurr = so_curr
       AND tcurr = tar_curr.

  IF sy-subrc = 0.
    converted_amount = amount * wa_currency_conversion-ukurs.
    conversion_found = abap_true.
    EXIT.
  ENDIF.

ENDLOOP.

* Display the result or error message
IF conversion_found = abap_true.
  WRITE: / 'Source Currency:', so_curr,
          / 'Target Currency:', tar_curr,
          / 'Amount:', amount,
          / 'Converted Amount:',converted_amount ,
          / 'Conversion Rate:', wa_currency_conversion-ukurs,
          / 'From:', wa_currency_conversion-fcurr,
          / 'To:', wa_currency_conversion-tcurr.
ELSE.
  MESSAGE 'Conversion rate not found for the specified currencies.' TYPE 'E'.
ENDIF.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 3.6.
"Data Dictionary – Student Database
"Write a report that sorts and prints all students from the previously created database table (3.5 and 3.4). Sort by last name, first name and date of birth. 
"The number of students should be determined and printed using an aggregate function.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Report Z30923_712_ASS3_6.

DATA: student_records TYPE TABLE OF z30923712_st_rec,
      wa_student      TYPE z30923712_st_rec,
      student_count   TYPE i.

* Read all student records from the database table
SELECT * FROM z30923712_st_rec INTO TABLE student_records.

* Determine the number of students
student_count = lines( student_records ).

* Sort the student records by last name, first name, and date of birth
SORT student_records BY last_name first_name date_of_birth.

* Display the sorted student records
LOOP AT student_records INTO wa_student.
  WRITE: / 'Matriculation Number:', wa_student-matri_num,
          / 'Name:', wa_student-first_name, wa_student-last_name,
          / 'Date of Birth:', wa_student-date_of_birth.
ENDLOOP.


