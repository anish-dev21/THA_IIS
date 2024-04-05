----------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 4.1
"Interactive Reporting – Student Database
"Copy your solution from 3.6. into a new report z30923_xxxx_StuRep and add a selection screen to the report that allows the data records output
"to berestricted according to date of birth and surname. To do this, use SELECT-OPTIONS. If a selection does not deliver a result, a suitable 
"message should be displayed.

----------------------------------------------------------------------------------------------------------------------------------------------------

DATA: wa_spfli             TYPE spfli,
      wa_sflight           TYPE sflight,
      occupancy_percentage TYPE f,
      occupied_seats       TYPE i,
      free_seats           TYPE i,
      output_col           TYPE c.

* Selection Screen
SELECT-OPTIONS: s_airln FOR wa_spfli-carrid OBLIGATORY.

* Display header
WRITE: / 'Flight Connection', 10 'Flight Date', 40 'Occupied Seats', 60 'Free Seats', 80 'Occupancy Status'.

* Select data from SPFLI and SFLIGHT tables
SELECT * FROM spfli INTO wa_spfli
  WHERE carrid IN s_airln.

  SELECT * FROM sflight INTO wa_sflight
    WHERE carrid = wa_spfli-carrid
      AND connid = wa_spfli-connid.

* Check if data is found
    IF sy-subrc = 0.

* Calculate occupied and free seats
      occupied_seats = wa_sflight-seatsocc.
      free_seats = wa_sflight-seatsmax - occupied_seats.

* Calculate occupancy percentage
      IF wa_sflight-seatsmax > 0.
        occupancy_percentage = ( occupied_seats / wa_sflight-seatsmax ) * 100.
      ELSE.
        occupancy_percentage = 0.
      ENDIF.

* Determine color based on occupancy percentage
      IF occupancy_percentage > 90.
        output_col = 'R'.  " Red
      ELSEIF occupancy_percentage > 80.
        output_col = 'Y'.  " Yellow
      ELSEIF occupancy_percentage > 50.
        output_col = 'G'.  " Green
      ELSE.
        output_col = 'W'.  " White (default)
      ENDIF.

* Display flight information with proper formatting and color
      WRITE: / wa_spfli-connid, 15 wa_sflight-fldate, 35 occupied_seats, 55 free_seats, 75 output_col.

    ELSE.
* Inform the user if no data is found for the selected airline(s)
      WRITE: / 'No data found for selected airline(s)'.

    ENDIF.

  ENDSELECT.

ENDSELECT.

----------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 4.2
"Interactive Reporting – Student Database
"Create a new report z30923_xxxx_NewStu to create new entries in the student database table. Check whether all entries on the selection 
"screen have been filled out completely. Also check whether an entry was created correctly or whether an error has occurred
"(e. g., due to a duplicate matriculation number). Additionally, display the number of entries in the database table.

----------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass4_2.

DATA: wa_new_student TYPE z30923712_st_rec,
      student_count  TYPE i.

* Selection Screen
PARAMETERS: p_mnum   TYPE z30923712_st_rec-matri_num OBLIGATORY,
            p_fname  TYPE z30923712_st_rec-first_name OBLIGATORY,
            p_lname  TYPE z30923712_st_rec-last_name OBLIGATORY,
            p_dbirth TYPE z30923712_st_rec-date_of_birth OBLIGATORY.

* Check if all required fields are filled out
IF p_mnum IS INITIAL OR
   p_fname IS INITIAL OR
   p_lname IS INITIAL OR
   p_dbirth IS INITIAL.
  WRITE: / 'Please fill out all required fields.'.
  EXIT.
ENDIF.

* Check if the matriculation number is unique
SELECT SINGLE * FROM z30923712_st_rec INTO wa_new_student
  WHERE matri_num = p_mnum.

IF sy-subrc = 0.
  WRITE: / 'Error: Matriculation number already exists. Please choose a unique one.'.
ELSE.
  wa_new_student-matri_num = p_mnum.
  wa_new_student-first_name = p_fname.
  wa_new_student-last_name = p_lname.
  wa_new_student-date_of_birth = p_dbirth.

  INSERT INTO z30923712_st_rec VALUES wa_new_student.

  WRITE: / 'New entry created successfully!'.

  SELECT COUNT( * ) FROM z30923712_st_rec INTO student_count.
  WRITE: / 'Number of entries in the database table:', student_count.
ENDIF.

----------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 4.3
"Interactive Reporting – Flight Database
"Create a report z30923_xxxx_Flights that displays the flights from the tables SPFLI and SFLIGHT with the respective flight date for each 
"flight connection. In addition, the number of occupied and free seats should be displayed for each flight (calculated from the number of 
"available and the number of occupied seats). To keep the output clear, it should be properly formatted with indentions.
"In addition, the flights are to be marked in color according to the occupancy: If more than 90% of the seats are occupied, the output should
"be red, more than 80% yellow, and more than 50% green.

----------------------------------------------------------------------------------------------------------------------------------------------------
REPORT z30923_712_ass4_3.

DATA: wa_spfli             TYPE spfli,
      wa_sflight           TYPE sflight,
      occupancy_percentage TYPE f,
      occupied_seats       TYPE i,
      free_seats           TYPE i,
      output_col           TYPE c.

* Display header
WRITE: / 'Flight Connection', 10 'Flight Date', 40 'Occupied Seats', 60 'Free Seats', 80 'Occupancy Status'.

* Select data from SPFLI and SFLIGHT tables
SELECT * FROM spfli INTO wa_spfli.

  SELECT * FROM sflight INTO wa_sflight
    WHERE carrid = wa_spfli-carrid
      AND connid = wa_spfli-connid.

* calculate occupied and free seats
    occupied_seats = wa_sflight-seatsocc.
    free_seats = wa_sflight-seatsmax - occupied_seats.

* calculate occupancy percentage
    if wa_sflight-seatsmax > 0.
    occupancy_percentage = ( occupied_seats / wa_sflight-seatsmax ) * 100.
  ELSE.
    occupancy_percentage = 0.
  ENDIF.

* determine color based on occupancy percentage
  if occupancy_percentage > 90.
  output_col = 'R'.  " Red
ELSEIF occupancy_percentage > 80.
  output_col = 'Y'.  " Yellow
ELSEIF occupancy_percentage > 50.
  output_col = 'G'.  " Green
ELSE.
  output_col = 'W'.  " White (default)
ENDIF.

* display flight information with proper formatting and color
write: / wa_spfli-connid, 15 wa_sflight-fldate, 35 occupied_seats, 55 free_seats, 75 output_col.

ENDSELECT.

ENDSELECT.

----------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 4.4
"Interactive Reporting – Flight Database
"Extend the program from 4.3. with the option to choose the airline. To do this, use the PARAMETERS command. If the user's selection does not 
"deliver a result, he should be informed of this by an output on the screen.

----------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass4_4.

DATA: wa_spfli             TYPE spfli,
      wa_sflight           TYPE sflight,
      occupancy_percentage TYPE f,
      output_col           TYPE c.

* Selection Screen
PARAMETERS: p_airl TYPE spfli-carrid OBLIGATORY.

* Display header
WRITE: / 'Flight Connection', 10 'Flight Date', 40 'Occupied Seats', 100 'Free Seats', 60 'Occupancy Status'.

* Select data from SPFLI and SFLIGHT tables
SELECT * FROM spfli INTO wa_spfli
  WHERE carrid = p_airl.

  SELECT * FROM sflight INTO wa_sflight
    WHERE carrid = wa_spfli-carrid
      AND connid = wa_spfli-connid.

* Check if data is found
    IF sy-subrc = 0.

* calculate occupancy percentage
      IF wa_sflight-seatsocc > 0 AND wa_sflight-seatsmax > 0.
        occupancy_percentage = ( wa_sflight-seatsocc / wa_sflight-seatsmax ) * 100.
      ELSE.
        occupancy_percentage = 0.
      ENDIF.

* determine color based on occupancy percentage
      IF occupancy_percentage > 90.
        output_col = 'R'.  " Red

      ELSEIF occupancy_percentage > 80.
        output_col = 'Y'.  " Yellow

      ELSEIF occupancy_percentage > 50.
        output_col = 'G'.  " Green

      ELSE.

        output_col = 'W'.  " White (default)

      ENDIF.

* display flight information with proper formatting and color
      WRITE: / wa_spfli-connid, 10 wa_sflight-fldate, 40 wa_sflight-seatsocc, 100 wa_sflight-seatsmax,
             60 output_col.

    ELSE.
* inform the user if no data is found for the selected airline
      WRITE: / 'No data found for airline', p_airl.

    ENDIF.

  ENDSELECT.

  ENDSELECT.

-----------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 4.5
"Interactive Reporting – Flight Database
"Now allow multiple airlines to be selected on the selection screen. To do this, use the SELECT-OPTIONS statement instead of the PARAMETERS command.

----------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass4_5.

DATA: wa_spfli             TYPE spfli,
      wa_sflight           TYPE sflight,
      occupancy_percentage TYPE f,
      occupied_seats       TYPE i,
      free_seats           TYPE i,
      output_col           TYPE c.

* Selection Screen
SELECT-OPTIONS: s_airln FOR wa_spfli-carrid OBLIGATORY.

* Display header
WRITE: / 'Flight Connection', 10 'Flight Date', 40 'Occupied Seats', 60 'Free Seats', 80 'Occupancy Status'.

* Select data from SPFLI and SFLIGHT tables
SELECT * FROM spfli INTO wa_spfli
  WHERE carrid IN s_airln.

  SELECT * FROM sflight INTO wa_sflight
    WHERE carrid = wa_spfli-carrid
      AND connid = wa_spfli-connid.

* Check if data is found
    IF sy-subrc = 0.

* Calculate occupied and free seats
      occupied_seats = wa_sflight-seatsocc.
      free_seats = wa_sflight-seatsmax - occupied_seats.

* Calculate occupancy percentage
      IF wa_sflight-seatsmax > 0.
        occupancy_percentage = ( occupied_seats / wa_sflight-seatsmax ) * 100.
      ELSE.
        occupancy_percentage = 0.
      ENDIF.

* Determine color based on occupancy percentage
      IF occupancy_percentage > 90.
        output_col = 'R'.  " Red
      ELSEIF occupancy_percentage > 80.
        output_col = 'Y'.  " Yellow
      ELSEIF occupancy_percentage > 50.
        output_col = 'G'.  " Green
      ELSE.
        output_col = 'W'.  " White (default)
      ENDIF.

* Display flight information with proper formatting and color
      WRITE: / wa_spfli-connid, 15 wa_sflight-fldate, 35 occupied_seats, 55 free_seats, 75 output_col.

    ELSE.
* Inform the user if no data is found for the selected airline(s)
      WRITE: / 'No data found for selected airline(s)'.

    ENDIF.

  ENDSELECT.

ENDSELECT.


-----------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 4.6
"Interactive Reporting – Flight Database
"Write a report z30923_xxxx_FlightTable that saves the name of the airline (table SCARR), the departure and arrival cities and the average number of
"occupied seats of all associated flights in an internal table for each flight connection. Use OpenSQL's aggregate functions where possible. Sort
"the entries in the internal table according to the average occupancy from smallest to largest and then output all entries on the screen.

----------------------------------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass4_6.

DATA: lt_flight_table  TYPE TABLE OF z30923_712_flight_table,
      ls_flight_table  TYPE z30923_712_flight_table,
      lt_sflight       TYPE TABLE OF sflight,
      ls_sflight       TYPE sflight,
      lv_avg_occupancy TYPE f.

* Internal table structure for flight table
TYPES: BEGIN OF zflight_table,
         carrid        TYPE scarr-carrid,
         carrname      TYPE scarr-carrname,
         cityfrom      TYPE spfli-cityfrom,
         cityto        TYPE spfli-cityto,
         avg_occupancy TYPE f,
       END OF zflight_table.

* Selection Screen
SELECT-OPTIONS: s_airline FOR scarr-carrid OBLIGATORY.

* Select data from SCARR and SFLIGHT tables
SELECT carrid carrname FROM scarr INTO TABLE lt_flight_table WHERE carrid IN s_airline.

LOOP AT lt_flight_table INTO ls_flight_table.

* calculate average occupancy using aggregate function avg
  select avg( seatsocc / seatsmax * 100 ) as avg_occupancy
    from sflight
    where carrid = ls_flight_table-carrid
      and connid in ( select connid from spfli where carrid = ls_flight_table-carrid ).

  ls_flight_table-avg_occupancy = lv_avg_occupancy.
  APPEND ls_flight_table TO lt_sflight.

ENDSELECT.

ENDLOOP.

* Sort the internal table by average occupancy in ascending order
SORT lt_sflight BY avg_occupancy ASCENDING.

* Display the sorted flight table
WRITE: / 'Airline', 10 'Airline Name', 35 'Departure City', 55 'Arrival City', 75 'Average Occupancy'.

LOOP AT lt_sflight INTO ls_sflight.
WRITE: / ls_sflight-carrid, 10 ls_sflight-carrname, 35 ls_sflight-cityfrom,
       55 ls_sflight-cityto, 75 ls_sflight-avg_occupancy.
ENDLOOP.


------------------------------------------------------------------------------------------------------------------------------------------
