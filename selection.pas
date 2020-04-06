unit selection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, EditBtn, display, fgl;

type
  TImageList = specialize TFPGObjectList<TImage>;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    DirectoryEdit1: TDirectoryEdit;
    FlowPanel1: TFlowPanel;
    ScrollBox1: TScrollBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    function IsPicture(FileName: String):boolean;
    function IsVideo(FileName: String):boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Files: TStringList;
  PicExts: TStringList;
  VidExts: TStringList;
  Images: TImageList;
  path: String;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  PicExts := TStringList.Create;
  PicExts.AddStrings(['.jpg','.jpeg','.gif','.bmp','.pcx','.png','.ppm',
  '.pds','.tga','.tpic','.tif','.tiff','.pgm','.pbm','.xpm','.xwd','.ico',
  '.cur','.icns']);
  PicExts.Sort;
  PicExts.Sorted:=true;

  VidExts := TStringList.Create;
  VidExts.AddStrings(['.mp4','.avi','.wmv','.vob']);
  VidExts.Sort;
  VidExts.Sorted:=true;
end;

procedure TForm1.Image1Click(Sender: TObject);
var
  FileName: String;
begin
  FileName:=Files.Strings[Images.IndexOf(TImage(Sender))];
  if IsPicture(FileName) then begin
    Form2.MPlayerControl1.Stop;
    Form2.MPlayerControl1.Visible:=false;
    Form2.Image1.Visible:=true;
    Form2.Image1.Picture:=TImage(Sender).Picture;
    Form2.Show;
  end else if IsVideo(FileName) then begin
    Form2.MPlayerControl1.Stop;
    Form2.Image1.Visible:=false;
    Form2.MPlayerControl1.Visible:=true;
    Form2.MPlayerControl1.Filename:=path+FileName;
    Form2.Show;
    Form2.MPlayerControl1.Play;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  SR: TSearchRec;
  i: Integer;
begin
  // Build list of available media files (path+Files[i])
  Images.Free;
  Files:=TStringList.Create;
  Images:=TImageList.Create;
  path:=DirectoryEdit1.Directory+'\';
  if FindFirst(path + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) and (IsPicture(SR.Name) or IsVideo(SR.Name)) then
      begin
        Files.Add(SR.Name);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  // Create Thumbnail list
  if Files.Count > 0 then begin
    for i := 0 to Files.Count-1 do begin
      Images.Add(TImage.Create(nil));
      with Images.Items[Images.Count-1] do begin
        Parent:=FlowPanel1;
        Center:=true;
        Proportional:=true;
        AntialiasingMode:=amOn;
        OnClick:=@Image1Click;
      end;
      if IsPicture(Files.Strings[i]) then  begin
        Images.Items[Images.Count-1].Picture.LoadFromFile(path+Files.strings[i]);
      end else if IsVideo(Files.Strings[i]) then begin   // Very very ugly part following. hope this doesn't kill anyone...
        if FileExists('shot0001.png') then
          DeleteFile('shot0001.png');
        while FileExists('shot0001.png') do begin end;
        Form2.MPlayerControl1.StartParam:='-vo direct3d';
        Form2.MPlayerControl1.Filename:=path+Files.Strings[i];
        Form2.MPlayerControl1.Volume:=0;
        Form2.MPlayerControl1.Play;
        Form2.MPlayerControl1.GrabImage;
        Form2.MPlayerControl1.Stop;
        Form2.MPlayerControl1.Volume:=100;
        while not FileExists('shot0001.png') do begin end;
        Sleep(1000);
        Images.Items[Images.Count-1].Picture.LoadFromFile('shot0001.png');
      end;
    end;
  end else begin
    ShowMessage ('Der gewählte Ordner enthält keine Bilder/Videos unterstützten Typs.');
  end;
end;

function TForm1.IsPicture(FileName: String):boolean;
begin
  Result:=PicExts.IndexOf(ExtractFileExt(FileName)) > -1;
end;

function TForm1.IsVideo(FileName: String):boolean;
begin
  Result:=VidExts.IndexOf(ExtractFileExt(FileName)) > -1;
end;

end.

