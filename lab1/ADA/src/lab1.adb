with ADA.Text_IO; use Ada.Text_IO;

with CreateList;

procedure Lab1 is

   package IntegerIO is new Ada.Text_IO.Integer_IO(Integer);
   use IntegerIO;

   size:integer;



begin

   put ("enter size for 'C' option: ");
   get(size);

   declare
      pt, length: integer;
      type Arr is array(integer range<>) of integer;

      Clist: Arr(1..size);

      procedure AddToList(x: in Integer) is
      begin
         if length<=size then
         length:= length+1;
         Clist(length):=x;
         put(x); put(" has been added to list");
         new_line;
         end if;

      end AddToList;

      procedure PrintList is --prints the entire list
      begin
         if length=0 then
            null;

         elsif length>0 then
            for x in 1..length loop
               Put(Clist(x)); put("");
            end loop;
      end if;
      new_line; new_line;
      end PrintList;

      procedure PrintItem(pt: in Integer) is
      begin
         put("The value at location: "); put(pt); put(" is "); put(Clist(pt)); new_line;
      end PrintItem;

      procedure DeleteItem(pt: in Integer) is
      begin
         if pt>=0 and pt<=length then
            for k in pt..(length-1) loop
               Clist(k):=Clist(k+1);
            end loop;
            put("Item at location: "); put(pt); put(" has been deleted");
            length := length-1;
            end if;

      end DeleteItem;

      function ListLength return integer is
      begin
         return length;
      end ListLength;


   begin

      PrintList;
      AddToList(12);
      AddToList(3);
      AddToList(7);
      new_Line;
      PrintList;



      for pt in 1..length loop
         PrintItem(pt);
      end loop;
      new_line; new_line;
      DeleteItem(2);

      PrintList;

   end;


   --********************************************************************************************
   --********************************************************************************************





   put ("enter size for 'B' option: ");
   get(size);

   declare

      package BList is new CreateList(3, float);
      use BList;



      floatNum: float;
      pt:integer:=0;

   begin
      PrintList;
      AddToList(12.7);
      AddToList(3.5);
      AddToList(7.6);
      AddToList(9.6);
      PrintItem(pt);

   end;





   --*****************************************************************************************************
   --*****************************************************************************************************



   put ("enter size for 'A' option: ");
   get(size);

   declare

      type JobType is (Programmer, Software_Engineer, Sales, Inventory_Control, Customer, Manager);

      package JobTypeIO is new Ada.Text_IO.Enumeration_IO(JobType);
      Use JobTypeIO;

      package AList is new CreateList(20 , JobType);
      use AList;

      pt, length: integer;
      job: JobType;



   begin



      AddToList( Programmer );
      AddToList (Software_Engineer );
      AddToList ( Software_Engineer );
      AddToList ( Sales );
      AddToList ( Customer );
      AddToList( Programmer );



      for pt in 1..size loop
         put("next ");
         PrintItem(pt);
         end loop;

      DeleteItem(4);



      AList.AddToList(job);
      AList.PrintItem(pt);


   end;




end Lab1;
