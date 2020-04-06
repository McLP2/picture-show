unit display;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LCLType,
  ExtCtrls, MPlayerCtrl;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    MPlayerControl1: TMPlayerControl;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MPlayerControl1Stop(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key = VK_F11 then
    if Form2.BorderStyle=bsNone then
      Form2.BorderStyle:=bsSizeable
    else
      Form2.BorderStyle:=bsNone;
end;

procedure TForm2.MPlayerControl1Stop(Sender: TObject);
begin
  MPlayerControl1.Visible:=false;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  MPlayerControl1.MPlayerPath:='\mplayer\mplayer.exe';
end;

end.

