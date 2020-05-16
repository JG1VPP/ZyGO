unit KeyEditDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TformKeyEditDlg = class(TForm)
    GroupBox1: TGroupBox;
    checkFuncAndCtrl: TCheckBox;
    checkFuncAndShift: TCheckBox;
    checkFuncAndAlt: TCheckBox;
    comboFunctionKey: TComboBox;
    GroupBox2: TGroupBox;
    comboAlphabetKey: TComboBox;
    checkAlphabetAndCtrl: TCheckBox;
    checkAlphabetAndAlt: TCheckBox;
    GroupBox3: TGroupBox;
    comboOtherKey: TComboBox;
    buttonOK: TButton;
    buttonCancel: TButton;
    procedure buttonOKClick(Sender: TObject);
  private
    { Private �錾 }
    procedure SetKey(v: string);
    function GetKey(): string;
  public
    { Public �錾 }
    property Key: string read GetKey write SetKey;
  end;

implementation

{$R *.dfm}

procedure TformKeyEditDlg.buttonOKClick(Sender: TObject);
begin

   ModalResult := mrOK
end;

procedure TformKeyEditDlg.SetKey(v: string);
var
   sl: TStringList;
   i: Integer;
   fCtrl: Boolean;
   fShift: Boolean;
   fAlt: Boolean;
   Index: Integer;
begin
   sl := TStringList.Create();
   sl.Delimiter := '+';
   try
      fCtrl := False;
      fShift := False;
      fAlt := False;
      sl.DelimitedText := v;
      for i := 0 to sl.Count - 1 do begin
         if sl[i] = 'Ctrl' then begin
            fCtrl := True;
         end
         else if sl[i] = 'Shift' then begin
            fShift := True;
         end
         else if sl[i] = 'Alt' then begin
            fAlt := True;
         end
         else begin
            Index := comboFunctionKey.Items.IndexOf(sl[i]);
            if Index <= 0 then begin
               comboFunctionKey.ItemIndex := 0;
            end
            else begin
               comboFunctionKey.ItemIndex := Index;
            end;

            Index := comboAlphabetKey.Items.IndexOf(sl[i]);
            if Index <= 0 then begin
               comboAlphabetKey.ItemIndex := 0;
            end
            else begin
               comboAlphabetKey.ItemIndex := Index;
            end;

            Index := comboOtherKey.Items.IndexOf(sl[i]);
            if Index <= 0 then begin
               comboOtherKey.ItemIndex := 0;
            end
            else begin
               comboOtherKey.ItemIndex := Index;
            end;
         end;
      end;

      if comboFunctionKey.ItemIndex > 0 then begin
         if fCtrl = True then begin
            checkFuncAndCtrl.Checked := True;
         end;
         if fShift = True then begin
            checkFuncAndShift.Checked := True;
         end;
         if fAlt = True then begin
            checkFuncAndAlt.Checked := True;
         end;
      end;

      if comboAlphabetKey.ItemIndex > 0 then begin
         if fCtrl = True then begin
            checkAlphabetAndCtrl.Checked := True;
         end;
         if fAlt = True then begin
            checkAlphabetAndAlt.Checked := True;
         end;
      end;
   finally
      sl.Free();
   end;
end;

function TformKeyEditDlg.GetKey(): string;
var
   sl: TStringList;
begin
   sl := TStringList.Create();
   sl.Delimiter := '+';
   try
      if comboFunctionKey.ItemIndex > 0 then begin
         if checkFuncAndCtrl.Checked = True then begin
            sl.Add('Ctrl');
         end;
         if checkFuncAndShift.Checked = True then begin
            sl.Add('Shift');
         end;
         if checkFuncAndAlt.Checked = True then begin
            sl.Add('Alt');
         end;
         sl.Add(comboFunctionKey.Items[comboFunctionKey.ItemIndex]);
      end
      else if comboAlphabetKey.ItemIndex > 0 then begin
         if checkAlphabetAndCtrl.Checked = True then begin
            sl.Add('Ctrl');
         end;
         if checkAlphabetAndAlt.Checked = True then begin
            sl.Add('Alt');
         end;
         sl.Add(comboAlphabetKey.Items[comboAlphabetKey.ItemIndex]);
      end
      else if comboOtherKey.ItemIndex > 0 then begin
         sl.Add(comboOtherKey.Items[comboOtherKey.ItemIndex]);
      end;

      Result := sl.DelimitedText;
   finally
      sl.Free();
   end;
end;

end.
