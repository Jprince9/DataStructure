with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;



procedure Lab2 is

   fileIn, fileOut: File_Type;
   inName : string := "lab2inputs.txt";
   outName : string := "lab2outputs.txt";


   package IIO is new Ada.Text_IO.Integer_IO(Integer);
   use IIO;

   package FIO is new Ada.Text_IO.Float_IO(Float);
   use FIO;

   -- Myput to output 2 decimal places
   procedure MyPut(x: float) is
   begin FIO.Put(fileout, x, fore => 10, aft => 2,exp => 0);
   end;

   type Code is (IL, IR, DL, DR, DD, PA, PD);
   package CodeIO is new Ada.Text_IO.Enumeration_IO(Code);
   use CodeIO;

   type DepartmentType is (Sales, Crew, IT, Media, Accounting, noDept);
   package DeptTypeIO is new Ada.Text_IO.Enumeration_IO(DepartmentType);
   use DeptTypeIO;

   type TitleType is (manager, sales_Person, Designer, Programmer, softwareEngineer, spokesPerson, Pilot, Copilot, Scientist, MissionSpecialist, noTitle);
   package TitleTypeIO is new Ada.Text_IO.Enumeration_IO(TitleType);
   use TitleTypeIO;

   type NameType is (Bob, Mary, Sally, David, Marty, Vallerie, Sam, Joe, noName);
   package NameTypeIO is new Ada.Text_IO.Enumeration_IO(NameType);
   use NameTypeIO;


   type empNode;
   type empPt is access empNode;


   type empNode is record
      deptName: DepartmentType :=noDept;
      empName: NameType:= noName;
      title: TitleType:= noTitle;
      id: Integer;
      payrate: Float;
      next: empPt:= null;
   end record;

   type departmentNode;
   type deptPt is access departmentNode;

   type departmentNode is record
      deptName: DepartmentType;
      empName: NameType;
      num: integer:= 0;
      next: empPt := null;
   end record;

   department: array(DepartmentType) of departmentNode;


   procedure Free is
     new Ada.Unchecked_Deallocation (empNode, empPt);


   procedure insertNodeLeft(deptNameIn: DepartmentType; empNameIn: NameType; titleIn: TitleType; idIn: Integer; payrateIn: Float) is
      pt: empPt;
   begin

      pt:= new empNode'(deptNameIn, empNameIn, titleIn, idIn, payrateIn, null);

      if (department(deptNameIn).next = NULL) then --list is empty, new first item
         pt.next:= pt;
         department(deptNameIn).next := pt;

         put(fileOut, "inserted "); put(fileOut, pt.empName); put(fileOut, " as the first item in the department: "); put(fileOut, deptNameIn);
         Put_Line(fileOut,""); Put_Line(fileOut, "");

      else -- list is not empty, add on left

         put(fileOut, "inserted "); put(fileOut, pt.empName); put(fileOut, " on the left side of the department: "); put(fileOut, deptNameIn);
         pt.next := Department(deptNameIn).next;
         department(deptNameIn).next:= pt;
         Put_Line(fileOut,"");Put_Line(fileOut,"");
      end if;

      Department(deptNameIn).num := department(deptNameIn).num + 1;

   end insertNodeLeft;




   procedure insertNodeRight(deptNameIn: DepartmentType; empNameIn: NameType; titleIn: TitleType; idIn: Integer; payrateIn: Float) is
      pt: empPt;
      ptr: empPT:= department(deptNameIn).next;

   begin
      pt:= new empNode'(deptNameIn, empNameIn, titleIn, idIn, payrateIn, null);

      if (department(deptNameIn).next = NULL) then --list is empty, new first item
         pt.next:= pt;
         department(deptNameIn).next := pt;

         put(fileOut,"inserted "); put(fileOut, pt.empName); put(fileOut, " as the first item in the department: "); put(fileOut, deptNameIn);
         Put_Line(fileOut,"");Put_Line(fileOut,"");

      else -- list is not empty, add on right
         for knt in 1..(department(deptNameIn).num) - 1 loop
            ptr:= ptr.next;

         end loop;

         put(fileOut, "inserted "); put(fileOut, pt.empName); put(fileOut, " on the right side of the department: "); put(fileOut, deptNameIn);
         put_line(fileOut,"");Put_Line(fileOut,"");

         pt.next:= department(deptNameIn).next;
         ptr.next := pt;

      end if;

      department(deptNameIn).num := department(deptNameIn).num + 1;

   end insertNodeRight;




   procedure deleteNodeLeft(deptNameIn: DepartmentType) is
      pt: empPt:= department(deptNameIn).next;
      dp: empPt:= pt;
   begin

      if (department(deptNameIn).next = NULL) then --list is empty
         put(fileout, deptNameIn); put(fileout, " deparment is empty");
         put_line(fileout, "");

      else --left most item deleted, list size reduced
         for knt in 1..(department(deptNameIn).num) - 1 loop
            pt:= pt.next;
         end loop;

         department(deptNameIn).next := dp.next;
         put(fileOut, dp.empName); put(fileOut, " has been removed from the left side of the department: "); put(fileOut, deptNameIn);
         Put_Line(fileOut, "");Put_Line(fileOut,"");

         pt.next := department(deptNameIn).next;
         department(deptNameIn).num := department(deptNameIn).num - 1;

         if department(deptNameIn).num = 0 then
            department(deptNameIn).next := NULL;
            put(fileOut, deptNameIn); put(fileOut, " department is now empty");
            put_line(fileOut, "");

            end if;

      end if;
      free(dp);

   end deleteNodeLeft;




   procedure deleteNodeRight(deptNameIn: DepartmentType) is

      dp: empPT:= department(deptNameIn).next;
      trail: empPT;
   begin
      if (department(deptNameIn).next = NULL) then --list is empty
         put_line(fileOut, "");

      else
         for knt in 1..department(deptNameIn).num loop
            trail:= dp;
            dp:= dp.next;
         end loop;
         trail.next := department(deptNameIn).next;
         department(deptNameIn).num := department(deptNameIn).num - 1;

         if department(deptNameIn).num = 0 then
            department(deptNameIn).next := NULL;
            put(fileOut, deptNameIn); put(fileOut, " department is now empty");
            put_line(fileOut, "");
            end if;
      end if;

      free(dp);

   end deleteNodeRight;




   procedure deleteDepartment(deptNameIn: DepartmentType) is
      dp: empPT:= department(deptNameIn).next;
      lead: empPT:= department(deptNameIn).next;
   begin

      for knt in 1..(department(deptNameIn).num) loop
         dp:= lead;
         lead:= lead.next;
         free (dp);
      end loop;

      put(fileout, deptNameIn); put(fileout, " department has been deleted");
      Put_Line(fileout, ""); put_line(fileout, "");
      department(deptNameIn).next := NULL;

   end deleteDepartment;




   procedure printAll is

      empPtr:empPT;

   begin
         put(fileout, "Printing all departments");
         put_line(fileout, "");put_line(fileout, "");
      for i in departmentType loop
         empPtr:= department(i).next;

         for knt in 1..(department(i).num) loop

            put(fileout, i,7); put(fileout," : ");
            put(fileout, empPtr.empName,8); put(fileOut, "  ");
            put(fileout, empPtr.title,12); put(fileout, "  ");
            put(fileout, empPtr.id,4); put(fileout, "  ");
            Myput(empPtr.payrate); put(fileout, "  ");
            Put_Line(fileout, "");
            empPtr := empPtr.next;

         end loop;
      end loop;
      put_line(fileout, "");
   end printAll;




   procedure printDept(deptNameIn: DepartmentType) is
      pt: empPt:= department(deptNameIn).next;
   begin
      if pt = NULL then
         put(fileOut, deptNameIn); put(fileOut, " department does not exist");
         put_line(fileOut,"");

      else

      for knt in 1..(department(deptNameIn).num) loop

            put(fileout, "Printing department: "); put(fileout, deptNameIn);
            put_line(fileOut, "");
            put(fileout, deptNameIn,7); put(fileout, " : ");
            put(fileOut, pt.empName,8); put(fileOut, "  ");
            put(fileOut, pt.title,12); put(Fileout, "  ");
            put(fileout, pt.id,4); put(fileout, "  ");
            Myput(pt.payrate); put(fileout, "  ");
            put_line(fileout, "");

            pt := pt.next;
         end loop;
      end if;
      put_line(fileout, "");
   end printDept;


   --declarations for reading from file
   CodePtr: Code;
   deptName: DepartmentType;
   empName: NameType;
   title: TitleType;
   id: Integer;
   payrate: Float;



begin


   Open(fileIn, In_File, inName);
   Create(fileOut, Out_File, outName);


   for i in 1..13 loop

         --use the CODE to call the function in case

      CodeIO.get(fileIn, CodePtr);


      case CodePtr is

         when IL => --insertNodeLeft;
            DeptTypeIO.get(fileIn, deptName);
            NameTypeIO.get(fileIn, empName);
            TitleTypeIO.get(fileIn, title);
            IIO.get(fileIn, id);
            FIO.get(fileIn, payrate);

            insertNodeLeft(deptName, empName, title, id, payrate);

         when IR => null; --insertNodeRight;
            DeptTypeIO.get(fileIn, deptName);
            NameTypeIO.get(fileIn, empName);
            TitleTypeIO.get(fileIn, title);
            IIO.get(fileIn, id);
            FIO.get(fileIn, payrate);

            insertNodeRight(deptName, empName, title, id, payrate);

         when DL => --deleteNodeLeft;
            DeptTypeIO.get(fileIn, deptName);

            deleteNodeLeft(deptName);

         when DR => --deleteNodeRight;

            DeptTypeIO.get(fileIn, deptName);

            deleteNodeRight(deptName);

         when DD => --deleteDepartment;

            DeptTypeIO.get(fileIn, deptName);

            deleteDepartment(deptName);

         when PA => --printAll;

            printAll;

         when PD => --printDept;

            DeptTypeIO.get(fileIn, deptName);

            printDept(deptName);

         when others => null;


      end case;
   end loop;



end Lab2;
