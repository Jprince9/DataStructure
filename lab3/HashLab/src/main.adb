--Joshua Prince
--COSC 3319 01 Data Structures
--DUE: 04/30/2021
--Lab 3 - Hashing
--Version 1.0
--
--

with ADA.Numerics.Elementary_Functions;
use ADA.Numerics.Elementary_Functions;
with Ada.Unchecked_Conversion;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   --file IO
   fileIn, fileOut: File_Type;
   inName : string := "lab3inputs.txt";
   outName : string := "lab3outputs.txt";

   --packages for IO
   package LIO is new ADa.Text_IO.Integer_IO(Standard.Long_Integer);
   use LIO;

   package IIO is new ADA.Text_IO.Integer_IO(Integer);
   use IIO;

   package FIO is new ADA.Text_IO.Float_IO(Float);
   use FIO;

   procedure Myput(x: float) is
   begin FIO.Put(fileOut, x, 0, 2, 0);
   end;

   --declarations
   HA: integer;
   OrigHA: integer;
   fs: String(1..16):= (others => ' ');
   R: Integer:= 1;
   tablesize: Integer:= 128;
   tablefullness: integer := Integer(tablesize * 0.85);


   --record used for storing hash
   type table is record
      key: string(1..16) := "----------------";
      hashaddress: integer:= 0;
      probes: integer:= 0;
   end record;

   type hashtable is array(1..tablesize) of table;
   type probetable is array(1..tablefullness) of integer;
   type readtable is array(1..tablefullness) of String(1..16);

   --functions and procedures

   --procedure to initiliaze the random number generator
   procedure InitialRandInteger is
   begin
      R:=1;
   end InitialRandInteger;

   --procedure to insert using linear probe
   procedure LinearInsert(table: in out hashtable; fillamount: integer; Address: integer; fs: String; probetab: in out probetable; counter:integer ) is
      count:integer := 1;
      probecount:integer := 1;
      HA: integer:= Address;
   begin
     while (count <= tablesize) loop --find the correct location for insertion, stops if table limit is reached(table is full)
            if table(HA).key = fs then --item already exists in table
               exit; --stops the loop
            elsif table(HA).key = "----------------" then --the index is empty, item inserted with 1 probe
               table(HA).key:= fs; --assigns key to string
               exit; --stops the loop
            else
               probecount:= probecount + 1; --number of probes taken incremented by 1
               HA := HA + 1; --index of the Hash address incremented by 1
               count:= count + 1;
               if HA > (tablesize) then
                  HA:= HA - tablesize; --reached end of table index, goes to index start of table
               end if;
            end if;
      end loop;
      probetab(counter):= probecount; --places number of probes used in each entry in order
      table(HA).probes := probecount; --assigns probes, default 1 unless index incremented
      table(HA).hashaddress := OrigHA; --assigns original address the string hashed to
   end LinearInsert;

   --procedure to print the entire hash table
   procedure printlist(table: in hashtable) is
      pt:integer:=1;
      tablesize:integer:= 128;
   begin
      Put_Line(fileout,"       index       key             original HA      probecount");
      Put_Line(fileout,"--------------------------------------------------------------");
      for pt in 1..tablesize loop
         put(fileOut, pt); put(fileOut, "   "); put(fileOut, table(pt).key); put(fileOut, "  "); --key within the table
         put(fileOut, table(pt).hashaddress,16); put(fileOut, "   "); --original address key hashed to
         put(fileOut, table(pt).probes,3); put(fileOut, "   "); --number of probes used
         Put_Line(fileOut, " ");
      end loop;
      Put_Line(fileOut, " ");
   end printlist;

   --procedure to print the first 30 items in the list with their min/max/average probes
   procedure first30(table: hashtable; probetab: probetable; readtab: readtable) is
      fs: String(1..16);
      pt: integer:= 1; minprobe: integer:= 1; maxprobe: integer:= 1;
      avgprobe: Float:= 0.0;
   begin
      Put_Line(fileout, "  key              probecount      hash address");
      Put_Line(fileout, "-----------------------------------------------");
      for counter in 1..30 loop --loops through the first 30 items in the list reading from the input file each item to match
         fs:= readtab(counter);
         pt:= 1;
         While pt < tablesize and then table(pt).key /= fs loop --loops until match is found
            pt:= pt+1; -- adds 1 index until match is found
         end loop;

         if probetab(counter) < minprobe then --checks for minimum probes used
            minprobe:= probetab(counter);
         elsif probetab(counter) > maxprobe then --checks for maximum probes  used
            maxprobe:= probetab(counter);
         end if;
         avgprobe:= avgprobe + Float(probetab(counter));
         put(fileOut, table(pt).key); put(fileOut, "  "); --matching key for first 30 items
         put(fileOut, table(pt).probes); put(fileOut, "  "); --number of probes after original hash
         put(fileOut, table(pt).hashaddress); put(fileOut, "  "); --original address it should have hashed to
         Put_Line(fileOut, " ");
      end loop;

      Put_Line(fileOut, " ");
      avgprobe:= (avgprobe/30.0);
      Put_Line(fileOut, "Results: ");
      put(fileOut, "average number of probes is "); Myput(avgprobe); Put_Line(fileOut, " "); --avg probe for first 30
      Put(fileOut, "max probe is "); Put(fileOut, maxprobe);Put_Line(fileOut, " ");  --max probe for first 30
      Put(fileOut, "min probe is "); Put(fileOut, minprobe);Put_Line(fileOut, " "); Put_Line(fileOut, " ");-- min probe for first 30
   end first30;

   --procedure to print the last 30 items in the list with their min/max/average probes
   procedure last30(table: hashtable; probetab: probetable; readtab: readtable; fillamount: integer) is
      fs: String(1..16);
      pt: integer:= 1; minprobe: integer:= 1; maxprobe: integer:= 1;
      avgprobe: Float:= 0.0;
   begin
      Put_Line(fileout, "  key              probecount      hash address");
      Put_Line(fileout, "-----------------------------------------------");
      for counter in (fillamount-29)..(fillamount) loop --reads the last 30 items
         fs:= readtab(counter);
         pt:=1;
         While pt< tablesize and then table(pt).key /= fs loop
            pt:= pt+1;
         end loop;
         if probetab(counter) < minprobe then --checks for minimum probes used
            minprobe:= probetab(counter);
         elsif probetab(counter) > maxprobe then --checks for maximum probes  used
            maxprobe:= probetab(counter);
         end if;
         avgprobe:= avgprobe + Float(probetab(counter));
         put(fileOut, table(pt).key); put(fileOut, "  "); --matching key for first 30 items
         put(fileOut, table(pt).probes); put(fileOut, "  "); --number of probes after original hash
         put(fileOut, table(pt).hashaddress); put(fileOut, "  "); --original address it should have hashed to
         Put_Line(fileOut, " ");
      end loop;
      avgprobe:= (avgprobe/30.0);
      Put_Line(fileOut, " ");
      Put_Line(fileOut, "Results: ");
      put(fileOut, "average number of probes is "); Myput(avgprobe); Put_Line(fileOut, " "); --avg probe for last 30
      Put(fileOut, "max probe is "); Put(fileOut, maxprobe); Put_Line(fileOut, " "); --max probe for last 30
      Put(fileOut, "min probe is "); Put(fileOut, minprobe); Put_Line(fileOut, " "); Put_Line(fileOut, " "); --min probe for last 30
   end last30;

   --procedure that prints results of entire table
   procedure results(table: hashtable; average: Float; fillamount: integer; expected: float) is
   begin
      put(fileOut, "number of items in table "); put(fileOut, fillamount);Put_Line(fileOut, " "); --items in table
      put(fileOut, "actual average probes is "); Myput(average);Put_Line(fileOut, " ");--average of all probes in table
      put(fileOut, "theoretical probes is "); myPut(expected);Put_Line(fileOut, " ");Put_Line(fileOut, " "); --theoretical of probe
   end results;

   --function to determine average probe count for entire list
   function averageprobe(table: hashtable; tablesize: integer; fillamount: integer) return Float is
      counter:integer:=1;
      avgprobe: Float:= 0.0;
   begin
      for counter in 1..tablesize loop --calculates the average number of probes for entire table
         avgprobe:= avgprobe + Float(table(counter).probes);
      end loop;
      avgprobe:= (avgprobe / Float(fillamount));
      return avgprobe;
   end averageprobe;

   --function used to return a random number
   Function UniqueRandInteger return Integer is
   begin
      R:= (5 * R) Mod (2 ** (7 + 2));
      return (R/4);
   end UniqueRandInteger;

   --function to convert characters to ints.0
   function convert is new Ada.Unchecked_Conversion(String, Integer);

   function shortconvert is new ADA.Unchecked_Conversion(String, Short_Integer);

   function charconvert is new ADA.Unchecked_Conversion(String, character);

   function shortchar is new ADA.Unchecked_Conversion(character, Integer);

   --function that returns hash address using given hash function
   function givenHash(fs: String) return Integer is
      Sum: Long_Integer:= 0;
      HA: Long_Integer:= 0;
      temp1:Long_Integer:= 0;
      temp2:Long_Integer:= 0;
      temp3:Long_Integer:= 0;
      char : character;
   begin
      temp1 := Long_Integer(2**16*(Convert(fs(fs'First..fs'First + 1))));
      temp1:= temp1/2**16;--converts to ascii
      temp2 := Long_Integer(2**16*(Convert(fs(fs'First + 14..fs'First + 15))));
      temp2:= temp2/2**16;--converts to ascii
      char:= charconvert(fs(fs'First + 7..fs'First + 7));--converts to character
      temp3 := Long_Integer(shortchar(char));--converts to ascii
      Sum := abs((abs(temp1)/3 + abs(temp2)/3)/2048 + abs(temp3));
      HA := abs(sum) mod Long_Integer(tablesize);

      return Integer(HA);
   end givenHash;

   --function that returns hash address using personal hash function
   function myHash(fs: String) return Integer is
      Sum: Long_Integer:= 0;
      HA: Long_Integer:= 0;
      temp1:Long_Integer:= 0;
      temp2:Long_Integer:= 0;
      temp3:Long_Integer:= 0;
      temp4:Long_Integer:= 0;
      char1, char2, char3, char4:character;
   begin
      char1:= charconvert(fs(1..1));
      temp1:= Long_Integer(4*(shortchar(char1)));
      temp1:= temp1/8;
      char2:= charconvert(fs(2..2));
      temp2:= Long_Integer(4*(shortchar(char2)));
      temp2:= temp2/8;
      char3:= charconvert(fs(3..3));
      temp3:= Long_Integer(4*(shortchar(char3)));
      temp3:= temp3/8;
      temp4:= Long_Integer(2**16*(convert(fs(7..8))));
      temp4:= temp4/2**16;
      Sum:= ((temp1**2)+(temp4**2))/2+(2*temp3)/3+temp2;
      HA:= Sum mod 128 + 1;
      return Integer(HA);
   end myHash;

   --procedure to insert using random probe
   procedure RandomInsert(table: in out hashtable; fillamount: integer; Address: integer; fs: String; probetab: in out probetable; counter:integer) is
      count:integer := 1;
      probecount:integer := 1;
      HA: integer:= Address; OrigHA: integer:= HA;
      R: integer:= 1;
   begin
      InitialRandInteger;
      while (count <= tablesize) loop --find the correct location for insertion, stops if table limit is reached(table is full)
         if table(HA).key = fs then --item already exists in table
            exit; --stops the loop
         elsif table(HA).key = "----------------" then --the index is empty, item inserted with 1 probe
            table(HA).key:= fs; --assigns key to string
            exit; --stops the loop
         else
            probecount:= probecount + 1; --number of probes taken incremented by 1
            HA := OrigHA + UniqueRandInteger; --increments hash address by random number
            count:= count + 1;
            if HA > (tablesize) then
               HA:= HA - tablesize; --reached end of table index, goes to index start of table
            end if;
         end if;
      end loop;
      probetab(counter):= probecount; --places number of probes used in each entry in order
      table(HA).probes := probecount; --assigns probes, default 1 unless index incremented
      table(HA).hashaddress := OrigHA; --assigns original address the string hashed to
   end RandomInsert;

begin

   Create(fileOut, Out_File, outName);


   --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      Atable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.55);
      areadtable: readtable;
      aprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := (1.0-a/2.0)/(1.0-a);
   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         areadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := givenHash(fs); --converts long sum into integer originalhashaddress
         LinearInsert(atable, tablefullness, OrigHA, fs, aprobetable,counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of A)");
      first30(atable,aprobetable,areadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of A)");
      last30(atable, aprobetable,areadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with given hash for Linear Collision 55% full");
      printlist(atable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(atable,tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of A)");
      results(Atable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;

   --BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
   --BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      btable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.85);
      breadtable: readtable;
      bprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := (1.0-a/2.0)/(1.0-a);
   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         breadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := givenHash(fs); --converts long sum into integer originalhashaddress
         LinearInsert(btable, tablefullness, OrigHA, fs, bprobetable,counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of B)");
      first30(btable,bprobetable,breadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of B)");
      last30(btable, bprobetable,breadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with given hash for Linear Collision 85% full");
      printlist(btable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(btable,tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of B)");
      results(btable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;

   --CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
   --CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

   -- Part A of C)
   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      CAtable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.55);
      CAreadtable: readtable;
      CAprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := -(1.0 / a)*log(1.0-a);
   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         CAreadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := givenHash(fs); --converts long sum into integer originalhashaddress
         RandomInsert(CAtable, tablefullness, OrigHA, fs, CAprobetable, counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of C) at 55%");
      first30(CAtable,CAprobetable,CAreadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of C) at 55%");
      last30(CAtable, CAprobetable,CAreadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with given hash for Random Collision 55% full");
      printlist(CAtable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(CAtable,tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of C) at 55%");
      results(CAtable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;

   --Part B of C)
   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      CBtable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.85);
      CBreadtable: readtable;
      CBprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := -(1.0 / a)*log(1.0-a);
   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         CBreadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := givenHash(fs); --converts long sum into integer originalhashaddress
         RandomInsert(CBtable, tablefullness, OrigHA, fs, CBprobetable, counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of C) at 85%");
      first30(CBtable,CBprobetable,CBreadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of C) at 85%");
      last30(CBtable, CBprobetable,CBreadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with given hash for Random Collision 85% full");
      printlist(CBtable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(CBtable,tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of C) at 85%");
      results(CBtable, avgprobe,tablefullness, expected);--prints results of table
      Close(fileIn);
   end;

   --EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
   --EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

   -- Part A of E)
   -- AEAE
   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      EAtable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.55);
      EAreadtable: readtable;
      EAprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := (1.0-a/2.0)/(1.0-a);
   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         EAreadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := myHash(fs); --converts long sum into integer originalhashaddress
         LinearInsert(EAtable, tablefullness, OrigHA, fs, EAprobetable,counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of EA) at 55% full");
      first30(EAtable,EAprobetable,EAreadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of EA) at 55% full");
      last30(EAtable, EAprobetable, EAreadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with Custom Hash for Linear Collision 55% full");
      printlist(EAtable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(EAtable,tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of EA) at 55% full");
      results(EAtable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;

   --Part B of E)
   -- BEBE

   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      Ebtable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.85);
      EBreadtable: readtable;
      EBprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := (1.0-a/2.0)/(1.0-a);
   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         EBreadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := myHash(fs); --converts long sum into integer originalhashaddress
         LinearInsert(EBtable, tablefullness, OrigHA, fs, EBprobetable,counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of EB) at 85% full");
      first30(EBtable,EBprobetable,EBreadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of EB) at 85% full");
      last30(EBtable, EBprobetable, EBreadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with Custom Hash for Linear Collision 85% full");
      printlist(EBtable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(EBtable,tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of EB) at 85% full");
      results(EBtable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;

   -- Part CA of E)
   -- CACA
   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      ECAtable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.55);
      ECAreadtable: readtable;
      ECAprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := -(1.0 / a)*log(1.0-a);

   begin
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         ECAreadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := myHash(fs); --converts long sum into integer originalhashaddress
         RandomInsert(ECAtable, tablefullness, OrigHA, fs, ECAprobetable, counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of EC) at 55%");
      first30(ECAtable,ECAprobetable,ECAreadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of EC) at 55%");
      last30(ECAtable, ECAprobetable, ECAreadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with custom hash for Random Collision 55% full");
      printlist(ECAtable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(ECAtable, tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of EC) at 55%");
      results(ECAtable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;

   --Part CB of E)
   --CBCB
   declare
      counter:integer:=1;
      avgprobe:float:=0.0;
      ECBtable: hashtable;
      tablefullness: integer := Integer(tablesize * 0.85);
      ECBreadtable: readtable;
      ECBprobetable: probetable;
      a: Float:= (Float(tablefullness) / Float(tablesize));
      expected: Float := -(1.0 / a)*log(1.0-a);

   begin
      InitialRandInteger;
      Open(fileIn, In_File, inName);
      for counter in 1..tablefullness loop --reads from file, fills table to 55% full
         get(fileIn, fs);
         ECBreadtable(counter) := fs; --stores strings from the input file into a seperate array in the order stored
         OrigHA := myHash(fs); --converts long sum into integer originalhashaddress
         RandomInsert(ECBtable, tablefullness, OrigHA, fs, ECBprobetable, counter);
         end loop;
      Put_Line(fileOut, "printing first 30 items of EC) at 85%");
      first30(ECBtable,ECBprobetable,ECBreadtable); --prints first 30, with min/max/average probes
      Put_Line(fileOut, "printing last 30 items of EC) at 85%");
      last30(ECBtable, ECBprobetable, ECBreadtable,tablefullness); --prints last 30 with min/max/average probes
      Put_Line(fileout, "Hash Table with custom hash for Random Collision 85% full");
      printlist(ECBtable);--this prints the entire contents of the table from starting index 1 through tablesize
      avgprobe:= averageprobe(ECBtable, tablesize, tablefullness); --function for calculating average probes
      Put_Line(fileOut, "Results of EC) at 85%");
      results(ECBtable, avgprobe,tablefullness, expected);--prints results of table
   Close(fileIn);
   end;
end Main;
