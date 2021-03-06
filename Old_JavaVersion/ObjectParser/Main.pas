unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AppEvnts, ExtCtrls, XPMan;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Button3: TButton;
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Panel3: TPanel;
    Image1: TImage;
    XPManifest1: TXPManifest;
    function GetFileName(fileName: string):string;
    procedure ParseFile(fileName, AndroidFolder: string);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PreParseMultiFile(fileName: string);
    procedure ParseMultiFile(fileName, AndroidFolder: string);
    procedure ParseMultiObjectFile(fileName: string);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  MainForm: TMainForm;
  obj: TStringList;
  path: string;
implementation

{$R *.dfm}
type

 floatBuf = array of single;
 pFloatBuf = ^floatBuf;

 intBuf = array of integer;
 pintBuf = ^intBuf;

var
 		vertexcount: integer;
	  texCount: integer;
		normalCount: integer;

			buf: pFloatBuf;
			tbuf: pFloatBuf;
			nbuf: pFloatBuf;


function TokenString(s: string):TStringList;
begin
 result := TStringList.Create;
 repeat
  if pos(' ', s) <> 0 then
   begin
    result.Add(copy(s, 1, pos(' ', s)-1));
    s := copy(s, pos(' ', s)+1, length(s));
   end
   else
    begin
     result.Add(s);
     s := '';
    end;

 until s = '';
end;

function TokenString2(s: string):TStringList;
begin
 result := TStringList.Create;
 repeat
  if pos('/', s) <> 0 then
   begin
    result.Add(copy(s, 1, pos('/', s)-1));
    s := copy(s, pos('/', s)+1, length(s));
   end
   else
    begin
     result.Add(s);
     s := '';
    end;

 until s = '';
end;
//------------------------------------------------------------------------------
function TMainForm.GetFileName(fileName: string):string;
var
 i: integer;
begin
  result := '';
  fileName := LowerCase(fileName);
  fileName := ExtractFileName(fileName);
  for i := 1 to length(fileName) do
   if fileName[i] <> '.' then result := result + fileName[i]
    else result := result + '_';

end;
//------------------------------------------------------------------------------
procedure TMainForm.ParseFile(fileName, AndroidFolder: string);
type

 floatBuf = array of single;
 pFloatBuf = ^floatBuf;

 intBuf = array of integer;
 pintBuf = ^intBuf;

var
 i: integer;
 tokenStr: TStringList;
 faceStr: TStringList;

		count: integer;
		faceCount: integer;
	  texCount: integer;
		normalCount: integer;

			buf: pFloatBuf;
			tbuf: pFloatBuf;
			nbuf: pFloatBuf;

			facebuf: pintBuf;
			normalbuf: pintBuf;
			texbuf: pintBuf;

      //-------------------

      textureBuf: pFloatBuf;
      resultBuf: pFloatBuf;
      normalResultBuf: pFloatBuf;

      F: File of single;

    j: integer;
    textureCount: integer;
    resCount: integer;

begin
    memo1.Lines.add(fileName);
    Application.ProcessMessages;
    try
		count := 0;
		faceCount := 0;
	  texCount := 0;
		normalCount := 0;
    DecimalSeparator := '.';



   obj := TStringList.Create;
   try
    obj.LoadFromFile(fileName);
   except
    Exit;
   end;


   for i := 1 to obj.Count-1  do
    begin
      tokenStr := TokenString(obj[i]);

      if tokenStr.Count = 0 then break;

      if tokenStr[0] = 'v' then count := count + 4
      else
      if tokenStr[0] = 'f' then facecount := facecount + 3
      else
      if tokenStr[0] = 'vt' then texcount := texcount + 2
      else
      if tokenStr[0] = 'vn' then normalcount := normalcount + 4;

      //tokenStr.Free;
    end;
    //------------------------------------------------------------------
    New(buf);
    SetLength(buf^, count + 4);
    New(tbuf);
    SetLength(tbuf^, texCount + 2);
    New(nbuf);
    SetLength(nbuf^, normalCount + 4);


  	count := 0;
		texCount := 0;
		normalCount := 0;

		New(facebuf);
    SetLength(facebuf^, faceCount);

		New(normalbuf);
    SetLength(normalbuf^, faceCount);

		New(texbuf);
    SetLength(texbuf^, faceCount);

		faceCount := 0;

   for i := 1 to obj.Count-1  do
    begin
      tokenStr := TokenString(obj[i]);
      if tokenStr.Count = 0 then break;

      if tokenStr[0] = 'v' then
       begin
        buf^[count] := StrToFloat( tokenStr[1]);
        buf^[count+1] := StrToFloat(tokenStr[2]);
        buf^[count+2] := StrToFloat(tokenStr[3]);
        buf^[count+3] := 1;
        count := count + 4
       end;

      if tokenStr[0] = 'vn' then
       begin
        nbuf^[normalcount] := StrToFloat( tokenStr[1]);
        nbuf^[normalcount+1] := StrToFloat(tokenStr[2]);
        nbuf^[normalcount+2] := StrToFloat(tokenStr[3]);
        nbuf^[normalcount+3] := 0;
        normalcount := normalcount + 4
       end;

      if tokenStr[0] = 'vt' then
       begin
        tbuf^[texcount] := StrToFloat( tokenStr[1]);
        tbuf^[texcount+1] := StrToFloat(tokenStr[2]);
        texcount := texcount + 2;
       end;

      if tokenStr[0] = 'f' then
      begin
        faceStr := TokenString2(tokenStr[1]);
				facebuf^[faceCount] := StrToInt(faceStr[0]);
				if faceStr[1] <> '' then texbuf^[faceCount] := StrToInt(faceStr[1]);
				normalbuf^[faceCount] := StrToInt(faceStr[2]);
        //faceStr.Free;

        faceStr := TokenString2(tokenStr[2]);
				facebuf^[faceCount+1] := StrToInt(faceStr[0]);
				if faceStr[1] <> '' then texbuf^[faceCount+1] := StrToInt(faceStr[1]);
				normalbuf^[faceCount+1] := StrToInt(faceStr[2]);
        //faceStr.Free;

        faceStr := TokenString2(tokenStr[3]);
				facebuf^[faceCount+2] := StrToInt(faceStr[0]);
				if faceStr[1] <> '' then texbuf^[faceCount+2] := StrToInt(faceStr[1]);
				normalbuf^[faceCount+2] := StrToInt(faceStr[2]);
        //faceStr.Free;

        faceCount := faceCount + 3;
      end;
    end;
 //  obj.Free;
   //-----------------------------------------------------


   faceCount :=  faceCount-1; //-6
   New(textureBuf);
   SetLength(textureBuf^, faceCount * 2+2);
   textureCount := 0;
   for i := 0 to faceCount {faceCount} do
    begin
      j := (texbuf^[i] - 1) * 2;
      textureBuf^[textureCount] := tbuf^[j];
      textureBuf^[textureCount+ 1] := 1- tbuf^[j + 1];

      textureCount := textureCount + 2;
    end;

    ForceDirectories(Edit2.Text + AndroidFolder);


    AssignFile(F, Edit2.Text + AndroidFolder + GetFileName(fileName) + '_texture');
    Rewrite(f);
    for i := 0 to textureCount-1 do
     Write(f, textureBuf^[i]);
    CloseFile(f);
   //-----------------------------------------------------

    resCount := 0;
    normalCount := 0;

    New(resultBuf);
    SetLength(resultBuf^, faceCount * 4 + 4);

    New(normalResultBuf);
    SetLength(normalResultBuf^, faceCount * 4 + 4);

   for i := 0 to faceCount do
    begin
      j := (facebuf^[i] - 1) * 4;
			resultBuf^[resCount] := buf^[j];
			resultBuf^[resCount + 1] := buf^[j + 1];
			resultBuf^[resCount + 2] := buf^[j + 2];
			resultBuf^[resCount + 3] := buf^[j + 3];
			resCount := resCount + 4;

    	j := (normalbuf^[i] - 1) * 4;
			normalResultBuf^[normalCount] := nbuf^[j];
			normalResultBuf^[normalCount + 1] := nbuf^[j + 1];
			normalResultBuf^[normalCount + 2] := nbuf^[j + 2];
			normalResultBuf^[normalCount + 3] := 0;

			normalCount := normalCount + 4;
    end;

    AssignFile(F, Edit2.Text + AndroidFolder + GetFileName(fileName) + '_vert');
    Rewrite(f);
    for i := 0 to resCount-1 do
    Write(f, resultBuf^[i]);
    CloseFile(f);

    AssignFile(F, Edit2.Text + AndroidFolder + GetFileName(fileName) + '_norm');
    Rewrite(f);
    for i := 0 to normalCount-1 do
    Write(f, normalResultBuf^[i]);
    CloseFile(f);
    except
     on E: Exception do memo1.Lines.add(e.Message);
    end;
    FreeAndNil(obj);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
 sr: TSearchRec;
 IsFound: integer;
begin
// FindFirst(Edit1.Text + '*', faAnyFile-faDirectory, sr);

 IsFound := FindFirst(Edit1.Text + '*.obj', faAnyFile-faDirectory, SR);
  while IsFound  = 0 do
   begin
    ParseFile(Edit1.Text + SR.Name, '');
    IsFound := FindNext(SR);
  end;
  FindClose(SR);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TMainForm.PreParseMultiFile(fileName: string);
var
 i: integer;
 tokenStr: TStringList;


			facebuf: pintBuf;
			normalbuf: pintBuf;
			texbuf: pintBuf;

      //-------------------

      textureBuf: pFloatBuf;
      resultBuf: pFloatBuf;
      normalResultBuf: pFloatBuf;

      F: File of single;

    j: integer;
    textureCount: integer;
    resCount: integer;

begin
    memo1.Lines.add(fileName);
    Application.ProcessMessages;
    try
		vertexcount := 0;

	  texCount := 0;
		normalCount := 0;
    DecimalSeparator := '.';



   obj := TStringList.Create;
   try
    obj.LoadFromFile(fileName);
   except
    Exit;
   end;


   for i := 1 to obj.Count-1  do
    begin
      tokenStr := TokenString(obj[i]);

      if tokenStr.Count = 0 then break;

      if tokenStr[0] = 'v' then vertexcount := vertexcount + 4
      else
      if tokenStr[0] = 'vt' then texcount := texcount + 2
      else
      if tokenStr[0] = 'vn' then normalcount := normalcount + 4;

      //tokenStr.Free;
    end;
    //------------------------------------------------------------------
    New(buf);
    SetLength(buf^, vertexcount + 4);
    New(tbuf);
    SetLength(tbuf^, texCount + 2);
    New(nbuf);
    SetLength(nbuf^, normalCount + 4);


  	vertexcount := 0;
		texCount := 0;
		normalCount := 0;


   for i := 1 to obj.Count-1  do
    begin
      tokenStr := TokenString(obj[i]);
      if tokenStr.Count = 0 then break;

      if tokenStr[0] = 'v' then
       begin
        buf^[vertexcount] := StrToFloat( tokenStr[1]);
        buf^[vertexcount+1] := StrToFloat(tokenStr[2]);
        buf^[vertexcount+2] := StrToFloat(tokenStr[3]);
        buf^[vertexcount+3] := 1;
        vertexcount := vertexcount + 4
       end;

      if tokenStr[0] = 'vn' then
       begin
        nbuf^[normalcount] := StrToFloat( tokenStr[1]);
        nbuf^[normalcount+1] := StrToFloat(tokenStr[2]); //Y<->Z
        nbuf^[normalcount+2] := StrToFloat(tokenStr[3]);
        nbuf^[normalcount+3] := 0;
        normalcount := normalcount + 4
       end;

      if tokenStr[0] = 'vt' then
       begin
        tbuf^[texcount] := StrToFloat( tokenStr[1]);
        tbuf^[texcount+1] := StrToFloat(tokenStr[2]);
        texcount := texcount + 2;
       end;
      end;

    except
     on E: Exception do memo1.Lines.add(e.Message);
    end;
end;

 //  obj.Free;
//-----------------------------------------------------
//-----------------------------------------------------
//-----------------------------------------------------

procedure TMainForm.ParseMultiFile(fileName, AndroidFolder: string);
const
 textureW = 4096;
 textureH = 4096;
var
 i: integer;
 tokenStr: TStringList;
 faceStr: TStringList;


		count: integer;
    faceCount: integer;


			facebuf: pintBuf;
			normalbuf: pintBuf;
			texbuf: pintBuf;



      textureBuf: pFloatBuf;
      resultBuf: pFloatBuf;
      normalResultBuf: pFloatBuf;

      F: File of single;

    j: integer;
    textureCount: integer;
    resCount: integer;

    //UVMap texture trigle coord
    x1, y1: integer;
    x2, y2: integer;
    x3, y3: integer;

begin
    memo1.Lines.add(fileName);
    Application.ProcessMessages;

    try




		faceCount := 0;
    DecimalSeparator := '.';



   obj := TStringList.Create;

   obj.LoadFromFile(fileName);



   for i := 1 to obj.Count-1  do
    begin
      tokenStr := TokenString(obj[i]);

      if tokenStr.Count = 0 then break;
      if tokenStr[0] = 'f' then facecount := facecount + 3


    end;


  	count := 0;
		texCount := 0;
		normalCount := 0;

    //sync loading data for all points (vertex) at trigle face
		New(facebuf);
    SetLength(facebuf^, faceCount);   // faceCount is vertex point count, for cube (in triagles) 12 faces, faceCount = 36

		New(normalbuf);
    SetLength(normalbuf^, faceCount);

		New(texbuf);
    SetLength(texbuf^, faceCount);   //

		faceCount := 0;

   for i := 1 to obj.Count-1  do
    begin
      tokenStr := TokenString(obj[i]);
      if tokenStr.Count = 0 then break;


      if tokenStr[0] = 'f' then  // f v1/t1/n1 v2/t2/n1 /v3/t3/n1
      begin
        faceStr := TokenString2(tokenStr[1]);
				facebuf^[faceCount] := StrToInt(faceStr[0]);
				if faceStr[1] <> '' then texbuf^[faceCount] := StrToInt(faceStr[1]);
				normalbuf^[faceCount] := StrToInt(faceStr[2]);
        //faceStr.Free;

        faceStr := TokenString2(tokenStr[2]);
				facebuf^[faceCount+1] := StrToInt(faceStr[0]);
				if faceStr[1] <> '' then texbuf^[faceCount+1] := StrToInt(faceStr[1]);
				normalbuf^[faceCount+1] := StrToInt(faceStr[2]);
        //faceStr.Free;

        faceStr := TokenString2(tokenStr[3]);
				facebuf^[faceCount+2] := StrToInt(faceStr[0]);
				if faceStr[1] <> '' then texbuf^[faceCount+2] := StrToInt(faceStr[1]);
				normalbuf^[faceCount+2] := StrToInt(faceStr[2]);
        //faceStr.Free;

        faceCount := faceCount + 3;
      end;
    end;

//UV Map writer BEGIN ----------------------------------------------------------
if CheckBox1.Checked then
 begin
   //for i := 0 to faceCount-1  do //DRAW UV map 1024x1024
   // begin
    memo1.Lines.Add(' building UVMap for ' + IntToStr(faceCount) + ' vertexes');

    self.DoubleBuffered := true;
    Image1.Picture.Bitmap := TBitmap.Create;
    Image1.Picture.Bitmap.Width := textureW;
    Image1.Picture.Bitmap.Height := textureH;

    try
    i := 0; //reset index
    repeat
      if i and 1000 = 1000 then
      Application.ProcessMessages;

      j := (texbuf^[i] - 1) * 2;
      x1 := trunc(tbuf^[j] / (1 / textureW));
      y1 := trunc((1 - tbuf^[j + 1]) / (1 / textureH));

      i := i + 1;
      j := (texbuf^[i] - 1) * 2;
      x2 := trunc(tbuf^[j] / (1 / textureW));
      y2 := trunc((1 - tbuf^[j + 1]) / (1 / textureH));

      i := i + 1;
      j := (texbuf^[i] - 1) * 2;
      x3 := trunc(tbuf^[j] / (1 / textureW));
      y3 := trunc((1 - tbuf^[j + 1]) / (1 / textureH));



      image1.Picture.Bitmap.Canvas.MoveTo(x1, y1);
      image1.Picture.Bitmap.Canvas.LineTo(x2, y2);
      image1.Picture.Bitmap.Canvas.LineTo(x3, y3);
      image1.Picture.Bitmap.Canvas.LineTo(x1, y1);

      i := i + 1;
      until i > faceCount;

      image1.Picture.Bitmap.SaveToFile(path + '\textures\' + extractfilename(fileName) + '.bmp');
      except
      end;

      memo1.Lines.Add(' end building UVMap');

 end;
//UV Map writer END ----------------------------------------------------------

   New(textureBuf);
   SetLength(textureBuf^, faceCount * 2); //2 point at one UV map 3 point vertex
   textureCount := 0;
   try
   for i := 0 to faceCount-1  do //for cube 36 vertex = 36 texture coord
    begin
      j := (texbuf^[i] - 1) * 2;
      textureBuf^[textureCount] := tbuf^[j];
      textureBuf^[textureCount+ 1] := 1- tbuf^[j + 1];
      textureCount := textureCount + 2;
    end;
    except
    end;

    ForceDirectories(Edit2.Text + AndroidFolder);


    AssignFile(F, Edit2.Text + AndroidFolder + GetFileName(fileName) + '_texture');
    Rewrite(f);
    for i := 0 to textureCount-1 do
     Write(f, textureBuf^[i]);
    CloseFile(f);
   //-----------------------------------------------------

    resCount := 0;
    normalCount := 0;

    New(resultBuf);
    SetLength(resultBuf^, faceCount * 4); //4 point to 1 vertex, x,y,z,1


    //New(normalResultBuf);
//    SetLength(normalResultBuf^, (faceCount div 3) * 4); //1 face (3 vertex) = 1 normal

    New(normalResultBuf);
    SetLength(normalResultBuf^, faceCount * 4);


   for i := 0 to faceCount-1  do
    begin
      j := (facebuf^[i] - 1) * 4;
			resultBuf^[resCount] := buf^[j];
			resultBuf^[resCount + 1] := buf^[j + 1];
			resultBuf^[resCount + 2] := buf^[j + 2];
			resultBuf^[resCount + 3] := buf^[j + 3];
			resCount := resCount + 4;

    	j := (normalbuf^[i] - 1) * 4;
			normalResultBuf^[normalCount] := nbuf^[j];
			normalResultBuf^[normalCount + 1] := nbuf^[j + 1];
			normalResultBuf^[normalCount + 2] := nbuf^[j + 2];
			normalResultBuf^[normalCount + 3] := 0;
			normalCount := normalCount + 4;

    end;

    //normals 1,1,1 2,2,2 n,n,n
    {
    i := 0;
  repeat
    	j := (normalbuf^[i] - 1) * 4;
			normalResultBuf^[normalCount] := nbuf^[j];
			normalResultBuf^[normalCount + 1] := nbuf^[j + 1];
			normalResultBuf^[normalCount + 2] := nbuf^[j + 2];
			normalResultBuf^[normalCount + 3] := 0;

			normalCount := normalCount + 4;
      i := i + 3;
 until i > faceCount-3;
 }

    AssignFile(F, Edit2.Text + AndroidFolder + GetFileName(fileName) + '_vert');
    Rewrite(f);
    for i := 0 to resCount-1 do
    Write(f, resultBuf^[i]);
    CloseFile(f);

    AssignFile(F, Edit2.Text + AndroidFolder + GetFileName(fileName) + '_norm');
    Rewrite(f);
    for i := 0 to normalCount - 1   do
    Write(f, normalResultBuf^[i]);
    CloseFile(f);
    except
     on E: Exception do memo1.Lines.add(e.Message);
    end;
    FreeAndNil(obj);
end;
//------------------------------------------------------------------------------
procedure TMainForm.ParseMultiObjectFile(fileName: string);
var
 s, objList, tempObj: TStringList;
 _file, objectFileName, AndroidFolder, temp: string;
 i: integer;

begin


 _file :=  ExtractFileName(fileName);
// AndroidFolder := GetFileName(_file) + '\';
 AndroidFolder := '';
 objectFileName := '';

 PreParseMultiFile(fileName);

 s := TStringList.Create;
 objList := TStringList.Create;
 tempObj := TStringList.Create;

 s.LoadFromFile(fileName);

 //parse multi object file to single objects files
 for i:=0 to s.Count-1 do
  begin
   if pos('o', s[i]) = 1 then //first or next object
    begin
     Application.ProcessMessages;
     if tempObj.Count > 0 then //pase single object to file if exists (first not exists)
      begin
        ForceDirectories(path + '\temp\' );
        tempObj.SaveToFile(path + '\temp\' + objectFileName); //parsed multiple data to single object file
        ParseMultiFile(path + '\temp\' + objectFileName, AndroidFolder); //parse the single file, fileName is multipleFileName+ObjectName from blender
      end;

      objectFileName := _file + copy(s[i], pos(' ', s[i]) + 1, length(s[i])) + '.obj'; //next object file name
      temp := GetFileName(_file + copy(s[i], pos(' ', s[i]) + 1, length(s[i])) + '.obj');
      objList.Add(temp);
      tempObj.Clear;
    end
   else //else copy object data to single file
    begin
     if (objectFileName <> '') then
        tempObj.Add(s[i])
    end;
  end; //-----------------------------------------------------------------------

  //save last object
     if tempObj.Count > 0 then
      begin
        ForceDirectories(path + '\temp\' );
        tempObj.SaveToFile(path + '\temp\' + objectFileName); //parsed multiple data to single object file
        ParseMultiFile(path + '\temp\' + objectFileName, AndroidFolder); //parse the single file, fileName is multipleFileName+ObjectName from blender
      end;



 objList.SaveToFile(Edit2.Text + AndroidFolder + GetFileName(fileName + '.lst'));
 s := nil;
 objList := nil;
 tempObj  := nil;


end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
 ParseMultiObjectFile(Edit3.Text);
end;

procedure TMainForm.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
    Memo1.Lines.Add(':: Exception - ' + E.Message);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    path := ExtractFileDir(ParamStr(0));
end;

end.
