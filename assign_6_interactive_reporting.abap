---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 6.1
"Interactive Reporting – Flight Database
"The following screenshots show the selection screen and the output list of an ABAP report. The report displays the flight connections with the name of the airline, the flight number, the place of
"departure and destination, and the associated flights with the date, price in the airline's local currency, and seat occupancy percentage. Flights that are more than 80 percent fully booked are
"marked with a "*".
"The flight connections to be output can be restricted on the selection screen by selecting departure and
"destination locations and a time period for the departure. Write the necessary ABAP code that generates the selection screen shown, the necessary database query and the output list. To do this, 
"use the tables of the flight data model known from the lecture.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT Z30923_712_ASS6_1 .
TABLES: sflight, spfli, scarr.

PARAMETERS: p_from TYPE string,
            p_to   TYPE string.

DATA: lv_from   TYPE string,    " Local variable for 'FROM' location
      lv_to     TYPE string,    " Local variable for 'TO' location
      lv_result TYPE p,         " Local variable for calculation result
      lv_maxs   TYPE p,         " Local variable for maximum seats
      lv_occs   TYPE p.         " Local variable for occupied seats


lv_from = p_from.
lv_to = p_to.

SELECT-OPTIONS so_date FOR sflight-fldate.

DATA: ls_sflight TYPE sflight,   " Structure variable for SFLIGHT table
      ls_spfli   TYPE spfli,     " Structure variable for SPFLI table
      ls_scarr   TYPE scarr.     " Structure variable for SCARR table

" Fetch airline information from SCARR
SELECT SINGLE * FROM scarr INTO ls_scarr WHERE carrid = 'LH'.

" Fetch flight information from SPFLI based on FROM, TO, and airline criteria
SELECT SINGLE * FROM spfli INTO ls_spfli
       WHERE cityfrom = lv_from AND cityto = lv_to AND carrid = ls_scarr-carrid.

" Display relevant information from SCARR and SPFLI
WRITE: /, ls_scarr-carrname, ls_spfli-connid, ls_spfli-cityfrom, ls_spfli-cityto.

" Fetch flight details from SFLIGHT based on connection ID, date range, and non-zero occupancy
SELECT * FROM sflight INTO ls_sflight
     WHERE connid = ls_spfli-connid AND fldate IN so_date AND seatsocc > 0.

" Calculate and display occupancy details
lv_maxs = ls_sflight-seatsmax + ls_sflight-seatsmax_b + ls_sflight-seatsmax_f.
lv_occs = ls_sflight-seatsocc + ls_sflight-seatsocc_b + ls_sflight-seatsocc_f.
lv_result = ( lv_occs * 100 ) / lv_maxs.

WRITE: /, ls_sflight-fldate, ls_sflight-price, ls_sflight-currency, lv_result, '%'.

" Highlight with '*' if occupancy is greater than 80%
IF lv_result > 80.
  WRITE: '*'.

      ENDIF.

    ENDSELECT. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 6.2
"Interactive Reporting – Flight Database
"Now adapt the report from 6.1. so that the selected data records are not printed on the screen directly, but are temporarily stored in an internal table. The internal table should have a locally
"defined structure gty_flight with the fields carrname, connid, cityto, cityfrom, fldate, price, currency and free. The types of the fields should be based on the column types of the database tables. 
"After filling the internal table, it should be sorted by flight date in descending order and by price in ascending order and then printed as output (see screenshot). The selection
"screen remains unchanged.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass6_2.


TABLES: sflight, spfli, scarr.

PARAMETERS: p_from TYPE string,
            p_to   TYPE string.

DATA: lv_from TYPE string,    " Local variable for 'FROM' location
      lv_to   TYPE string.    " Local variable for 'TO' location

TYPES: BEGIN OF gty_flight,
         carrname TYPE scarr-carrname,
         connid   TYPE spfli-connid,
         cityto   TYPE spfli-cityto,
         cityfrom TYPE spfli-cityfrom,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
         currency TYPE sflight-currency,
         free     TYPE p,
       END OF gty_flight.

DATA: lt_flights TYPE TABLE OF gty_flight, " Internal table to store flight data
      ls_flight  TYPE gty_flight.       " Structure variable for lt_flights

lv_from = p_from.
lv_to = p_to.

SELECT-OPTIONS so_date FOR sflight-fldate.

DATA: ls_sflight TYPE sflight,   " Structure variable for SFLIGHT table
      ls_spfli   TYPE spfli,     " Structure variable for SPFLI table
      ls_scarr   TYPE scarr.     " Structure variable for SCARR table

" Fetch airline information from SCARR
SELECT SINGLE * FROM scarr INTO ls_scarr WHERE carrid = 'LH'.

" Fetch flight information from SPFLI based on FROM, TO, and airline criteria
SELECT SINGLE * FROM spfli INTO ls_spfli
       WHERE cityfrom = lv_from AND cityto = lv_to AND carrid = ls_scarr-carrid.

" Fetch flight details from SFLIGHT based on connection ID, date range, and non-zero occupancy
SELECT * FROM sflight INTO ls_sflight
     WHERE connid = ls_spfli-connid AND fldate IN so_date AND seatsocc > 0.

  " Fill internal table with selected data records
  CLEAR ls_flight.
  ls_flight-carrname = ls_scarr-carrname.
  ls_flight-connid = ls_spfli-connid.
  ls_flight-cityto = ls_spfli-cityto.
  ls_flight-cityfrom = ls_spfli-cityfrom.
  ls_flight-fldate = ls_sflight-fldate.
  ls_flight-price = ls_sflight-price.
  ls_flight-currency = ls_sflight-currency.
  ls_flight-free = ls_sflight-seatsmax - ls_sflight-seatsocc.
  APPEND ls_flight TO lt_flights.

ENDSELECT.

" Sort the internal table by flight date in descending order and by price in ascending order
SORT lt_flights BY fldate DESCENDING price ASCENDING.

" Display header for the output
WRITE: / '  Carr. Name    ', '   Conn. ID ', 'City To  ', '      City From   ', '       Flight Date ', '            Price  ',
 'Currency   ', '  Free Seats '.
SKIP.

" Print the sorted internal table as output
LOOP AT lt_flights INTO ls_flight.
  WRITE: / ls_flight-carrname, ls_flight-connid, ls_flight-cityto, ls_flight-cityfrom,
         ls_flight-fldate, ls_flight-price, ls_flight-currency, ls_flight-free.
ENDLOOP.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 6.3
"Interactive Reporting – Flight Database
"Copy and revise your implementation of Exercise 6.2. so that with the keys <F4>, <F5> or <F6> you can sort the list by price, flight date or occupancy. To do this, the unsorted basic list needs to be
"displayed first. After that, a detail list should be generated in each case sorted according to the key pressed.
"If a key is pressed several times (e. g., <F4> twice), then the list should switch between sorted ascending and sorted descending. Use the Events TOP-OF-PAGE or TOP-OF-PAGE DURING LINE-SELECTION to 
"tell the user which sorting options he has and according to which criterion the sorting is currently taking place.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass6_3.

TABLES: sflight, spfli, scarr.

PARAMETERS: p_from TYPE string,
            p_to   TYPE string.


TYPES: BEGIN OF gty_flight,
         carrname TYPE scarr-carrname,
         connid   TYPE spfli-connid,
         cityto   TYPE spfli-cityto,
         cityfrom TYPE spfli-cityfrom,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
         currency TYPE sflight-currency,
         free     TYPE p,
       END OF gty_flight.


DATA: lv_from            TYPE string,    " Local variable for 'FROM' location
      lv_to              TYPE string,    " Local variable for 'TO' location
      lt_flights         TYPE TABLE OF gty_flight, " Internal table to store flight data
      ls_flight          TYPE gty_flight,       " Structure variable for lt_flights
      gv_sort_key        TYPE sy-ucomm,     " Variable to store the user command (F4, F5, F6)
      gv_sort_descending TYPE abap_bool.  " Indicator for descending sort order

lv_from = p_from .
lv_to = p_to.

SELECT-OPTIONS so_date FOR sflight-fldate.


TOP-OF-PAGE.

  WRITE: 'Press F4 to sort it by Price.Press F5 to sort by Flight Date. Press F6 to sort by Occupancy', /
        ,'Press one time for Ascending order and press two times for Descending order'.
  ULINE.


  DATA: ls_sflight TYPE sflight,   " Structure variable for SFLIGHT table
        ls_spfli   TYPE spfli,     " Structure variable for SPFLI table
        ls_scarr   TYPE scarr.     " Structure variable for SCARR table

START-OF-SELECTION.

  SELECT sc~carrname, sp~connid , sp~cityfrom, sp~cityto, sf~fldate,sf~price, sf~currency,
    division( sf~seatsocc * 100 , seatsmax , 1 ) AS free
     FROM sflight AS sf
    JOIN spfli AS sp
    ON sf~connid = sp~connid
    JOIN scarr AS sc
    ON sc~carrid = sp~carrid
      WHERE sp~cityfrom = @lv_from
    AND sp~cityto = @p_to
    AND sf~fldate IN @so_date
      INTO TABLE @lt_flights.

  PERFORM display.



TOP-OF-PAGE DURING LINE-SELECTION.

  IF sy-lsind = 1.

    WRITE: 'Sorted by Price'.
    ULINE.

  ENDIF.

  IF sy-lsind = 2.

    WRITE: 'Sorted by Flight Date'.
    ULINE.

  ENDIF.

  IF sy-lsind = 3.

    WRITE: 'Sorted by Occupancy'.
    ULINE.

  ENDIF.


AT PF4.
  sy-lsind = 1.
  IF gv_sort_key = 1.
    SORT lt_flights BY price ASCENDING.
    gv_sort_key = 2.
  ELSE.
    SORT lt_flights BY price DESCENDING.
    gv_sort_key = 1.
  ENDIF.

  PERFORM display.

AT PF5.
  sy-lsind = 2.
  IF gv_sort_key = 1.
    SORT lt_flights BY fldate ASCENDING.
    gv_sort_key = 2.
  ELSE.
    SORT lt_flights BY fldate DESCENDING.
    gv_sort_key = 1.
  ENDIF.

  PERFORM display.

AT PF6.
  sy-lsind = 3.
  IF gv_sort_key = 1.
    SORT  lt_flights BY free ASCENDING.
    gv_sort_key = 2.
  ELSE.
    SORT  lt_flights BY free DESCENDING.
    gv_sort_key = 1.
  ENDIF.

  PERFORM display.

FORM display.

  IF sy-subrc <> 0.
    WRITE 'Problem reading data'.
  ELSE.
    LOOP AT  lt_flights INTO ls_flight.
      WRITE:/, ls_flight-carrname , ls_flight-connid, ls_flight-cityfrom, ls_flight-cityto, ls_flight-fldate,
      ls_flight-price, ls_flight-currency, ls_flight-free, '%'.

      IF ls_flight-free > 80.
        WRITE: '*'.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 6.4
"Interactive Reporting – Flight Database
"Now the report from 6.3. should be extended by the option to display the list of bookings with the names and addresses of the customers from the SCUSTOM table by double-clicking on an list data record 
"(flight) (→ HIDE). Again, use appropriate Events from 6.3. to indicate to the user what is displayed on the current list. Required Tables 1: scarr, spfli, sflight.Required Tables 2: sflight, sbook, scustom

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass6_4.

TABLES: sflight, spfli, scarr, sbook,scustom.

PARAMETERS: p_from TYPE string,
            p_to   TYPE string.


TYPES: BEGIN OF gty_flight,
         carrname TYPE scarr-carrname,
         connid   TYPE spfli-connid,
         cityto   TYPE spfli-cityto,
         cityfrom TYPE spfli-cityfrom,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
         currency TYPE sflight-currency,
         free     TYPE p,
       END OF gty_flight.


DATA: lv_from            TYPE string,    " Local variable for 'FROM' location
      lv_to              TYPE string,    " Local variable for 'TO' location
      lt_flights         TYPE TABLE OF gty_flight, " Internal table to store flight data
      ls_flight          TYPE gty_flight,       " Structure variable for lt_flights
      gv_sort_key        TYPE sy-ucomm,     " Variable to store the user command (F4, F5, F6)
      gv_sort_descending TYPE abap_bool,  " Indicator for descending sort order
      ls_sbook           TYPE sbook,
      ls_scustom         TYPE scustom.


      lv_from = p_from.
      lv_to = p_to.

SELECT-OPTIONS so_date FOR sflight-fldate.


TOP-OF-PAGE.

  WRITE: 'Press F4 to sort it by Price.Press F5 to sort by Flight Date. Press F6 to sort by Occupancy', /
        ,'Press one time for Ascending order and press two times for Descending order'.
  ULINE.


  DATA: ls_sflight TYPE sflight,   " Structure variable for SFLIGHT table
        ls_spfli   TYPE spfli,     " Structure variable for SPFLI table
        ls_scarr   TYPE scarr.     " Structure variable for SCARR table

START-OF-SELECTION.

  SELECT sc~carrname, sp~connid , sp~cityfrom, sp~cityto, sf~fldate,sf~price, sf~currency,
    division( sf~seatsocc * 100 , seatsmax , 1 ) AS free
     FROM sflight AS sf
    JOIN spfli AS sp
    ON sf~connid = sp~connid
    JOIN scarr AS sc
    ON sc~carrid = sp~carrid
      WHERE sp~cityfrom = @lv_from
    AND sp~cityto = @p_to
    AND sf~fldate IN @so_date
      INTO TABLE @lt_flights.

  PERFORM display.

AT LINE-SELECTION.
  WRITE: 'The customers of the selected flight are: '.
  WRITE:/, (15) 'Title' , (25) 'Name' , (30) 'Street' , (9) 'PLZ' ,
          (25) 'City' , (25) 'Country'.

  SELECT * FROM sbook INTO ls_sbook WHERE connid = ls_flight-connid.
    SELECT * FROM scustom INTO ls_scustom WHERE id = ls_sbook-customid.
      WRITE:/,ls_scustom-form, ls_scustom-name , ls_scustom-street,
              ls_scustom-postcode, ls_scustom-city, ls_scustom-country.
    ENDSELECT.
  ENDSELECT.

TOP-OF-PAGE DURING LINE-SELECTION.

  IF sy-lsind = 1.

    WRITE: 'Sorted by Price'.
    ULINE.

  ENDIF.

  IF sy-lsind = 2.

    WRITE: 'Sorted by Flight Date'.
    ULINE.

  ENDIF.

  IF sy-lsind = 3.

    WRITE: 'Sorted by Occupancy'.
    ULINE.

  ENDIF.


AT PF4.
  sy-lsind = 1.
  IF gv_sort_key = 1.
    SORT lt_flights BY price ASCENDING.
    gv_sort_key = 2.
  ELSE.
    SORT lt_flights BY price DESCENDING.
    gv_sort_key = 1.
  ENDIF.

  PERFORM display.

AT PF5.
  sy-lsind = 2.
  IF gv_sort_key = 1.
    SORT lt_flights BY fldate ASCENDING.
    gv_sort_key = 2.
  ELSE.
    SORT lt_flights BY fldate DESCENDING.
    gv_sort_key = 1.
  ENDIF.

  PERFORM display.

AT PF6.
  sy-lsind = 3.
  IF gv_sort_key = 1.
    SORT  lt_flights BY free ASCENDING.
    gv_sort_key = 2.
  ELSE.
    SORT  lt_flights BY free DESCENDING.
    gv_sort_key = 1.
  ENDIF.

  PERFORM display.

FORM display.

  IF sy-subrc <> 0.
    WRITE 'Problem reading data'.
  ELSE.
    LOOP AT  lt_flights INTO ls_flight.
      WRITE:/, ls_flight-carrname , ls_flight-connid, ls_flight-cityfrom, ls_flight-cityto, ls_flight-fldate,
      ls_flight-price, ls_flight-currency, ls_flight-free, '%'.

      IF ls_flight-free > 80.
        WRITE: '*'.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.







