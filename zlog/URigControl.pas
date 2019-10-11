unit URigControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UzLogGlobal, StdCtrls, BGK32Lib, ExtCtrls, CPDrv, OmniRig_TLB;

type
  TIcomInfo = record
    name : string[10];
    addr : byte;
    minband, maxband : TBand;
  end;

const
  MAXVIRTUALRIG = 10;
  _nil : char = Chr($00);
  _nil2 : string = Chr($0) + Chr($0);
  _nil3  = chr(0)+chr(0)+chr(0);
  _nil4  = chr(0)+chr(0)+chr(0)+chr(0);

  MAXICOM = 26;

  ICOMLIST : array[1..MAXICOM] of TIcomInfo =
     (
       (name: 'IC-706'; addr: $48; minband: b19; maxband: b144),
       (name: 'IC-706MkII'; addr: $4E; minband: b19; maxband: b144),
       (name: 'IC-706MkII-G'; addr: $58; minband: b19; maxband: b430),
       (name: 'IC-718'; addr: $5E; minband: b19; maxband: b28),
       (name: 'IC-721'; addr: $28; minband: b19; maxband: b28),
       (name: 'IC-726'; addr: $30; minband: b19; maxband: b50),
       (name: 'IC-731'; addr: $04; minband: b19; maxband: b28),
       (name: 'IC-736'; addr: $40; minband: b19; maxband: b50),
       (name: 'IC-738'; addr: $44; minband: b19; maxband: b28),
       (name: 'IC-746'; addr: $56; minband: b19; maxband: b144),
       (name: 'IC-746PRO'; addr: $66; minband: b19; maxband: b144),
       (name: 'IC-7400'; addr: $66; minband: b19; maxband: b144),

       (name: 'IC-750'; addr: $1C; minband: b19; maxband: b28),
       (name: 'IC-756'; addr: $50; minband: b19; maxband: b50),
       (name: 'IC-756PRO'; addr: $5C; minband: b19; maxband: b50),
       (name: 'IC-756PROII'; addr: $64; minband: b19; maxband: b50),
       (name: 'IC-760'; addr: $1E; minband: b19; maxband: b28),
       (name: 'IC-760PRO'; addr: $2C; minband: b19; maxband: b28),
       (name: 'IC-775'; addr: $46; minband: b19; maxband: b28),
       (name: 'IC-780'; addr: $26; minband: b19; maxband: b28),
       (name: 'IC-820'; addr: $42; minband: b144; maxband: b430),
       (name: 'IC-821'; addr: $4C; minband: b144; maxband: b430),
       (name: 'IC-910'; addr: $60; minband: b144; maxband: b1200),
       (name: 'IC-970'; addr: $2E; minband: b144; maxband: b1200),
       (name: 'IC-275'; addr: $10; minband: b144; maxband: b144),
       (name: 'IC-375'; addr: $14; minband: b430; maxband: b430)
     );

  BaseMHz : array[b19..b10g] of LongInt =
    (   1900000,
        3500000,
        7000000,
       10000000,
       14000000,
       18000000,
       21000000,
       24000000,
       28000000,
       50000000,
      144000000,
      430000000,
     1200000000,
              0,
              0,
              0);

  VFOString : array[0..1] of string =
    ('VFO A', 'VFO B');

type
  TVirtualRig = record
    Callsign : string;
    Band : TBand;
    Mode : TMode;
    FirstTime : Boolean;
  end;

  TRig = class
    FILO : boolean; // FILO buffer flag used for YAESU
    Name : string;
    _freqoffset : LongInt; // freq offset for transverters in Hz
    _minband, _maxband : TBand;
    _rignumber : Integer;
    FreqMem : array[b19..b10g, mCW..mOther] of LongInt;
    TerminatorCode : char;
    BufferString : string;
    _currentfreq : array[0..1] of LongInt; // in Hz
    _currentband : TBand;
    _currentmode : TMode;
    _currentvfo : integer; // 0 : VFO A; 1 : VFO B
    _lastcallsign : string;
    Comm : TCommPortDriver; // points to the right CommPortDriver
    LastFreq : LongInt;
    RigAddr : byte; // for icom

    ModeWidth : array[mCW..mOther] of Integer; // used in icom

    constructor Create(RigNum : integer); virtual;
    destructor Destroy; virtual;
    function Selected : boolean;
    function CurrentFreqHz : LongInt; //in Hz
    function CurrentFreqKHz : LongInt;
    function CurrentFreqkHzStr : string;
    procedure PallingProcess; virtual;
    procedure SetMode(Q : TQSO); virtual; abstract;
    procedure SetBand(Q : TQSO); virtual; // abstract;
    procedure ExecuteCommand(S : string); virtual; abstract;
    procedure PassOnRxData(S : string); virtual;
    procedure ParseBufferString; virtual; abstract;
    procedure RitClear; virtual; abstract;
    procedure SetFreq(Hz : LongInt); virtual; abstract;
    procedure Reset; virtual; abstract; // called when user wants to reset the rig
                                        // after power outage etc
    procedure SetVFO(i : integer); virtual; abstract; // A:0, B:1
    procedure ToggleVFO;
    procedure VFOAEqualsB; virtual;
    procedure UpdateStatus; virtual;// Renews RigControl Window and Main Window
    procedure WriteData(str : string);
    procedure InquireStatus; virtual; abstract;
    procedure MoveToLastFreq; virtual;
    procedure SetStopBits(i : byte);
    procedure SetBaudRate(i : integer);
  end;

  TTS690 = class(TRig) // TS-450 as well
    _CWR : boolean; // CW-R flag
    constructor Create(RigNum : integer); override;
    destructor Destroy; override;
    procedure SetMode(Q : TQSO); override;
    procedure ExecuteCommand(S : string); override;
    procedure ParseBufferString; override;
    procedure RitClear; override;
    procedure SetFreq(Hz : LongInt); override;
    procedure Reset; override;
    procedure SetVFO(i : integer); override;
    procedure InquireStatus; override;
  end;

  TTS2000 = class(TTS690)
    constructor Create(RigNum : integer); override;
  end;

  TTS2000P = class(TTS2000)
    constructor Create(RigNum : integer); override;
    Procedure PallingProcess; override;
    destructor Destroy; override;
  end;

  TICOM = class(TRig) // Icom CI-V
    MyAddr : Byte;
    constructor Create(RigNum : integer); override;
    destructor Destroy; override;
    procedure SetMode(Q : TQSO); override;
    procedure ExecuteCommand(S : string); override;
    procedure ParseBufferString; override;
    procedure RitClear; override;
    procedure SetFreq(Hz : LongInt); override;
    procedure Reset; override;
    procedure SetVFO(i : integer); override;
    procedure InquireStatus; override;
    procedure ICOMWriteData(S : string);
  end;

  TIC756 = class(TICOM)
    procedure SetVFO(i : integer); override;
  end;

  TFT1000MP = class(TRig)
    WaitSize : integer;
    constructor Create(RigNum : integer); override;
    destructor Destroy; override;
    procedure SetMode(Q : TQSO); override;
    procedure ExecuteCommand(S : string); override;
    procedure ParseBufferString; override;
    procedure RitClear; override;
    procedure SetFreq(Hz : LongInt); override;
    procedure Reset; override;
    procedure SetVFO(i : integer); override;
    procedure InquireStatus; override;
    procedure PallingProcess; override;
    procedure PassOnRxData(S : string); override;
  end;

  TMARKVF = class(TFT1000MP)
    procedure ExecuteCommand(S : string); override;
    procedure RitClear; override;
  end;

  TFT1000 = class(TFT1000MP)
    procedure ExecuteCommand(S : string); override;
    procedure RitClear; override;
    procedure SetVFO(i : integer); override;
  end;

  TMARKV = class(TFT1000MP)
    procedure ExecuteCommand(S : string); override;
    procedure RitClear; override;
    procedure SetVFO(i : integer); override;
  end;

  TFT847 = class(TFT1000MP)
    constructor Create(RigNum : integer); override;
    destructor Destroy; override;
    procedure ExecuteCommand(S : string); override;
    procedure RitClear; override;
    procedure SetVFO(i : integer); override;
    procedure SetFreq(Hz : LongInt); override;
    procedure SetMode(Q : TQSO); override;
    procedure PallingProcess; override;
  end;

  TFT817 = class(TFT847)
    procedure SetFreq(Hz : LongInt); override;
    procedure SetMode(Q : TQSO); override;
  end;

  TFT920 = class(TFT1000MP)
    constructor Create(RigNum : integer); override;
    procedure ExecuteCommand(S : string); override;
  end;

  TFT100 = class(TFT1000MP)
    constructor Create(RigNum : integer); override;
    procedure ExecuteCommand(S : string); override;
    procedure SetVFO(i : integer); override;
    procedure RitClear; override;
  end;

  TJST145 = class(TRig) //  or JST245
    CommOn, CommOff : string;
    constructor Create(RigNum : integer); override;
    destructor Destroy; override;
    procedure SetMode(Q : TQSO); override;
    procedure ExecuteCommand(S : string); override;
    procedure ParseBufferString; override;
    procedure RitClear; override;
    procedure SetFreq(Hz : LongInt); override;
    procedure Reset; override;
    procedure SetVFO(i : integer); override;
    procedure InquireStatus; override;
    procedure PallingProcess; override;
  end;

  TOmni = class(TRig)
    constructor Create(RigNum : integer); override;
    destructor Destroy; override;
    procedure PassOnRxData(S : string); override;
    procedure ExecuteCommand(S : string); override;
    procedure ParseBufferString; override;
    procedure RitClear; override;
    procedure SetFreq(Hz : LongInt); override;
    procedure SetMode(Q : TQSO); override;
    procedure InquireStatus; override;
    procedure SetVFO(i : integer); override;
    procedure UpdateStatus; override;
    procedure Reset; override;
  end;

  TRigControl = class(TForm)
    dispMode: TLabel;
    Button1: TButton;
    RigLabel: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    PallingTimer: TTimer;
    ZCom1: TCommPortDriver;
    ZCom2: TCommPortDriver;
    ZCom3: TCommPortDriver;
    dispFreqA: TStaticText;
    dispFreqB: TStaticText;
    dispVFO: TStaticText;
    btnOmniRig: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PallingTimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ZCom1ReceiveData(Sender: TObject; DataPtr: Pointer; DataSize: Cardinal);
    procedure btnOmniRigClick(Sender: TObject);
  private
    { Private declarations }
    procedure VisibleChangeEvent(Sender: TObject);
    procedure RigTypeChangeEvent(Sender: TObject; RigNumber: Integer);
    procedure StatusChangeEvent(Sender: TObject; RigNumber: Integer);
    procedure ParamsChangeEvent(Sender: TObject; RigNumber: Integer; Params: Integer);
    procedure CustomReplyEvent(Sender: TObject; RigNumber: Integer; Command, Reply: OleVariant);
    procedure BuildRigObject(var rig: TRig);
  public
    { Public declarations }
    Rig1 : TRig;
    Rig2 : TRig;
    Rig : TRig;
    OmniRig : TOmniRigX;
    TempFreq : array [b19..HiBand] of Double; //  temp. freq storage when rig is not connected. in kHz
    VirtualRig : array[1..MAXVIRTUALRIG] of TVirtualRig;
    _currentrig : integer; // 1 or 2
    _maxrig : integer; // default = 2.  may be larger with virtual rigs
    procedure SetSerialCWKeying(PortNr : integer);
    function StatusSummaryFreq(kHz : integer): string; // returns current rig's band freq mode
    function StatusSummaryFreqHz(Hz : integer): string; // returns current rig's band freq mode
    function StatusSummary: string; // returns current rig's band freq mode
    procedure ImplementOptions;
    procedure SetCurrentRig(N : integer);
    function GetCurrentRig : integer;
    function ToggleCurrentRig : integer;
    procedure SetBandMask;
    function CheckSameBand(B : TBand) : boolean; // returns true if inactive rig is in B
  end;

function GetBand(Hz : LongInt) : integer;  //Returns -1 if Hz is outside ham bands

var
  RigControl: TRigControl;

implementation

uses
  UOptions, Main, UFreqList, UZLinkForm, UBandScope2;

{$R *.DFM}

function kHzStr(Hz: LongInt): string;
var
   S: string;
begin
   S := IntToStr(Hz mod 1000);
   while length(S) < 3 do begin
      S := '0' + S;
   end;

   S := IntToStr(Hz div 1000) + '.' + S;

   Result := S;
end;

function GetBand(Hz: LongInt): Integer; // Returns -1 if Hz is outside ham bands
var
   i: LongInt;
begin
   i := -1;
   case Hz of
      1800000 .. 1999999:
         i := 0;
      3000000 .. 3999999:
         i := 1;
      6900000 .. 7999999:
         i := 2;
      9900000 .. 11000000:
         i := 3;
      13900000 .. 14999999:
         i := 4;
      17500000 .. 18999999:
         i := 5;
      20900000 .. 21999999:
         i := 6;
      23500000 .. 24999999:
         i := 7;
      27800000 .. 29999999:
         i := 8;
      49000000 .. 59000000:
         i := 9;
      140000000 .. 149999999:
         i := 10;
      400000000 .. 450000000:
         i := 11;
      1200000000 .. 1299999999:
         i := 12; {
        2400000000..2499999999 : i := 13;
        5600000000..5699999999 : i := 14;
        10000000000..90000000000 : i := 15; }
   end;

   Result := i;
end;

procedure TRigControl.SetSerialCWKeying(PortNr: Integer);
begin
   ZCom3.Port := TPortNumber(PortNr);
   ZCom3.Connect;
end;

function TRigControl.StatusSummaryFreq(kHz: Integer): string; // returns current rig's band freq mode
var
   S, ss: string;
begin
   S := '';

   if dmZlogGlobal.Settings._multistation = True then begin
      ss := '30';
   end
   else begin
      ss := IntToStr(Ord(Main.CurrentQSO.QSO.Band));
   end;

   ss := FillRight(ss, 3);

   S := ss + S;
   S := S + FillRight(MHzString[Main.CurrentQSO.QSO.Band], 5);
   S := S + FillRight(IntToStr(kHz), 8);
   S := S + FillRight(ModeString[Main.CurrentQSO.QSO.Mode], 5);

   ss := TimeToStr(CurrentTime);
   if Main.CurrentQSO.QSO.CQ then begin
      ss := 'CQ ' + ss + ' ';
   end
   else begin
      ss := 'SP ' + ss + ' ';
   end;

   S := S + ss + ' [' + dmZlogGlobal.Settings._pcname + ']';

   Result := S;
end;

function TRigControl.StatusSummaryFreqHz(Hz: Integer): string; // returns current rig's band freq mode
var
   S, ss: string;
begin
   S := '';

   if dmZlogGlobal.Settings._multistation = True then begin
      ss := '30';
   end
   else begin
      ss := IntToStr(Ord(Main.CurrentQSO.QSO.Band));
   end;

   ss := FillRight(ss, 3);
   S := ss + S;
   S := S + FillRight(MHzString[Main.CurrentQSO.QSO.Band], 5);
   S := S + FillRight(FloatToStrF(Hz / 1000.0, ffFixed, 12, 1), 8);
   S := S + FillRight(ModeString[Main.CurrentQSO.QSO.Mode], 5);
   ss := TimeToStr(CurrentTime);

   if Main.CurrentQSO.QSO.CQ then begin
      ss := 'CQ ' + ss + ' ';
   end
   else begin
      ss := 'SP ' + ss + ' ';
   end;

   S := S + ss + ' [' + dmZlogGlobal.Settings._pcname + ']';

   Result := S;
end;

function TRigControl.StatusSummary: string; // returns current rig's band freq mode
begin
   Result := '';
   if Rig = nil then begin
      Exit;
   end;

   if Rig.CurrentFreqKHz > 60000 then begin
      Result := StatusSummaryFreq(Rig.CurrentFreqKHz);
   end
   else begin
      Result := StatusSummaryFreqHz(Rig.CurrentFreqHz);
   end;
end;

function TRigControl.CheckSameBand(B: TBand): Boolean; // returns true if inactive rig is in B
var
   R: TRig;
begin
   Result := False;
   if _currentrig = 1 then begin
      R := Rig2;
   end
   else begin
      R := Rig1;
   end;

   if R <> nil then begin
      if R._currentband = B then begin
         Result := True;
      end;
   end;
end;

procedure TRigControl.SetCurrentRig(N: Integer);
var
   str: string;
begin
   if (N > _maxrig) or (N < 0) then begin
      Exit;
   end;

   if Rig <> nil then begin
      str := Main.CurrentQSO.QSO.Callsign;
      if length(str) > 0 then begin
         if str[1] = ',' then begin
            str := '';
         end;
      end;

      Rig._lastcallsign := str;
   end
   else begin // could be virtual rig
      if _currentrig > 0 then begin
         str := Main.CurrentQSO.QSO.Callsign;
         if length(str) > 0 then begin
            if str[1] = ',' then begin
               str := '';
            end;
         end;

         VirtualRig[_currentrig].Callsign := str;
         VirtualRig[_currentrig].Band := Main.CurrentQSO.QSO.Band;
         VirtualRig[_currentrig].Mode := Main.CurrentQSO.QSO.Mode;
      end;
   end;

   _currentrig := N;
   Rig := nil;
   case _currentrig of
      1:
         Rig := Rig1;
      2:
         Rig := Rig2;
   end;

   if Rig = nil then begin
      if _currentrig > 0 then begin // virtual rig
         RigLabel.Caption := 'Current rig : ' + IntToStr(_currentrig) + ' (Virtual)';
         BGK32Lib.SetRigFlag(0);
         if VirtualRig[_currentrig].FirstTime then begin
            VirtualRig[_currentrig].FirstTime := False;
         end
         else begin
            // RigControl.dispVFO.Caption := VFOString[_currentvfo];
            MainForm.UpdateMode(VirtualRig[_currentrig].Mode);
            // RigControl.dispMode.Caption := ModeString[_currentmode];
            MainForm.UpdateBand(VirtualRig[_currentrig].Band);
            // RigControl.dispFreq.Caption :=kHzStr(_currentfreq)+' kHz';
            // if VirtualRig[_currentrig].Callsign <> '' then
            MainForm.CallsignEdit.Text := VirtualRig[_currentrig].Callsign;
            str := 'R' + IntToStr(_currentrig);
            MainForm.StatusLine.Panels[1].Text := str;
         end;
      end
      else begin
         RigLabel.Caption := 'Current rig : ' + IntToStr(_currentrig) + ' (None)';
         BGK32Lib.SetRigFlag(0);
         MainForm.StatusLine.Panels[1].Text := 'R' + IntToStr(_currentrig);
      end;
   end
   else begin
      Rig.InquireStatus;
      RigLabel.Caption := 'Current rig : ' + IntToStr(_currentrig) + ' (' + Rig.name + ')';
      BGK32Lib.SetRigFlag(_currentrig);
      Rig.UpdateStatus;
      // if Rig._lastcallsign <> '' then
      MainForm.CallsignEdit.Text := Rig._lastcallsign;
   end;
end;

procedure TRigControl.SetBandMask;
var
   B: TBand;
begin
   B := b19;
   case dmZlogGlobal.Settings._banddatamode of
      1:
         if Rig1 <> nil then
            B := Rig1._currentband;
      2:
         if Rig2 <> nil then
            B := Rig2._currentband;
      3:
         B := Main.CurrentQSO.QSO.Band;
   end;

   BGK32Lib._bandmask := (dmZlogGlobal.Settings._BandData[B] * 16);
   BGK32Lib.UpdateDataPort;
end;

function TRigControl.GetCurrentRig: Integer;
begin
   Result := _currentrig;
end;

function TRigControl.ToggleCurrentRig: Integer;
var
   i: Integer;
begin
   if _currentrig < _maxrig then begin
      i := _currentrig + 1;
   end
   else begin
      i := 1;
   end;

   SetCurrentRig(i); // _currentrig is changed by SetCurrentRig;

   Result := _currentrig;
end;

procedure TRig.PallingProcess;
begin
end;

procedure TRig.SetStopBits(i: byte);
begin
   case i of
      1:
         Comm.StopBits := sb1BITS;
      2:
         Comm.StopBits := sb2BITS;
   end;
end;

procedure TRig.SetBaudRate(i: Integer);
begin
   case i of
      300:     Comm.BaudRate := br300;
      1200:    Comm.BaudRate := br1200;
      2400:    Comm.BaudRate := br2400;
      4800:    Comm.BaudRate := br4800;
      9600:    Comm.BaudRate := br9600;
      19200:   Comm.BaudRate := br19200;
      38400:   Comm.BaudRate := br38400;
   end;
end;

function TRig.Selected: Boolean;
begin
   if _rignumber = RigControl._currentrig then
      Result := True
   else
      Result := False;
end;

procedure TTS690.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      WriteData('FR0;FT0;')
   else
      WriteData('FR1;FT1;');

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TJST145.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      WriteData(CommOn + 'FA' + _CR + CommOff)
   else
      WriteData(CommOn + 'FB' + _CR + CommOff);

   WriteData('I1' + _CR);

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TICOM.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      ICOMWriteData(Chr($07) + Chr($00))
   else
      ICOMWriteData(Chr($07) + Chr($01));

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TIC756.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   if _currentvfo <> i then begin
      _currentvfo := i;
      ICOMWriteData(Chr($07) + Chr($B0));
   end;

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TFT1000MP.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      WriteData(_nil3 + Chr(0) + Chr($05))
   else
      WriteData(_nil3 + Chr(2) + Chr($05));

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TFT1000.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = 32 then begin
      if _currentvfo = 0 then
         i := Ord(S[8])
      else
         i := Ord(S[8 + 16]);

      case i of
         0, 1:
            M := mSSB;
         2:
            M := mCW;
         3:
            M := mAM;
         4:
            M := mFM;
         5:
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := Ord(S[2]) * 256 * 256 + Ord(S[3]) * 256 + Ord(S[4]);
      i := i * 10;
      _currentfreq[0] := i;
      i := i + _freqoffset;

      if _currentvfo = 0 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0];
      end;

      i := Ord(S[18]) * 256 * 256 + Ord(S[19]) * 256 + Ord(S[20]);
      i := i * 10;
      _currentfreq[1] := i;
      i := i + _freqoffset;

      if _currentvfo = 1 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[1];
      end;

   end;

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TFT1000.RitClear;
begin
   WriteData(_nil3 + Chr($FF) + Chr($09));
end;

procedure TFT1000.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      WriteData(_nil3 + Chr(0) + Chr($05))
   else
      WriteData(_nil3 + Chr(1) + Chr($05));

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TMARKV.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = 32 then begin
      if _currentvfo = 0 then
         i := Ord(S[8])
      else
         i := Ord(S[8 + 16]);

      case i of
         0, 1:
            M := mSSB;
         2:
            M := mCW;
         3:
            M := mAM;
         4:
            M := mFM;
         5:
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := (Ord(S[5]) mod 16) * 100000000 + (Ord(S[5]) div 16) * 10000000 + (Ord(S[4]) mod 16) * 1000000 + (Ord(S[4]) div 16) * 100000 +
        (Ord(S[3]) mod 16) * 10000 + (Ord(S[3]) div 16) * 1000 + (Ord(S[2]) mod 16) * 100 + (Ord(S[2]) div 16) * 10;
      _currentfreq[0] := i;
      i := i + _freqoffset;

      if _currentvfo = 0 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0];
      end;

      i := (Ord(S[21]) div 16) * 100000000 + (Ord(S[21]) mod 16) * 10000000 + (Ord(S[20]) div 16) * 1000000 + (Ord(S[20]) mod 16) * 100000 +
        (Ord(S[19]) div 16) * 10000 + (Ord(S[19]) mod 16) * 1000 + (Ord(S[18]) div 16) * 100 + (Ord(S[18]) mod 16) * 10;
      _currentfreq[1] := i;
      i := i + _freqoffset;

      if _currentvfo = 1 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[1];
      end;

   end;

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TMARKV.RitClear;
begin
   WriteData(_nil3 + Chr($FF) + Chr($09));
end;

procedure TMARKV.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      WriteData(_nil3 + Chr(0) + Chr($05))
   else
      WriteData(_nil3 + Chr(1) + Chr($05));
   if Selected then
      UpdateStatus;
end;

procedure TMARKVF.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = 32 then begin
      if _currentvfo = 0 then begin
         i := Ord(S[8])
      end
      else begin
         i := Ord(S[8 + 16]);
      end;

      case i of
         0, 1:
            M := mSSB;
         2:
            M := mCW;
         3:
            M := mAM;
         4:
            M := mFM;
         5:
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := Ord(S[2]) * 256 * 256 * 256 + Ord(S[3]) * 256 * 256 + Ord(S[4]) * 256 + Ord(S[5]);
      i := i * 10;
      _currentfreq[0] := i;
      i := i + _freqoffset;

      if _currentvfo = 0 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0];
      end;

      i := Ord(S[18]) * 256 * 256 * 256 + Ord(S[19]) * 256 * 256 + Ord(S[20]) * 256 + Ord(S[21]);
      i := i * 10;
      _currentfreq[1] := i;
      i := i + _freqoffset;

      if _currentvfo = 1 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[1];
      end;

   end;
   if Selected then
      UpdateStatus;
end;

procedure TMARKVF.RitClear;
begin
   WriteData(_nil3 + Chr($FF) + Chr($09));
end;

procedure TRig.ToggleVFO;
begin
   if _currentvfo = 0 then
      SetVFO(1)
   else
      SetVFO(0);
end;

procedure TRig.WriteData(str: string);
begin
   // repeat until Comm.OutQueCount = 0;
   if Comm = nil then begin
      Exit;
   end;

   if Comm.Connected then begin
      Comm.SendString(str);
   end;
end;

procedure TRigControl.BuildRigObject(var rig: TRig);
var
   rname: string;
   i: Integer;
begin
   FreeAndNil(rig);

   if dmZlogGlobal.Rig1NameStr = 'Omni-Rig' then begin
      rig := TOmni.Create(1);
      rig._minband := b19;
      rig._maxband := b1200;
      btnOmniRig.Enabled := True;
   end
   else begin
      btnOmniRig.Enabled := False;
   end;

   if dmZlogGlobal.Settings._rig1port in [1 .. 6] then begin
      rname := dmZlogGlobal.Rig1NameStr;
      if rname = 'None' then begin
         Exit;
      end;

      if rname = 'TS-690/450' then begin
         rig := TTS690.Create(1);
         rig._minband := b19;
         rig._maxband := b50;
      end;
      if rname = 'TS-850' then begin
         rig := TTS690.Create(1);
         rig._minband := b19;
         rig._maxband := b28;
      end;
      if rname = 'TS-790' then begin
         rig := TTS690.Create(1);
         rig._minband := b144;
         rig._maxband := b1200;
      end;

      if rname = 'TS-2000' then begin
         rig := TTS2000.Create(1);
         rig._minband := b19;
         rig._maxband := b2400;
      end;

      if rname = 'TS-2000/P' then begin
         rig := TTS2000P.Create(1);
         rig._minband := b19;
         rig._maxband := b2400;
      end;

      if rname = 'FT-1000MP' then begin
         rig:= TFT1000MP.Create(1);
         rig._minband := b19;
         rig._maxband := b28;
      end;

      if rname = 'MarkV/FT-1000MP' then begin
         rig:= TMARKV.Create(1);
         rig._minband := b19;
         rig._maxband := b28;
      end;

      if rname = 'FT-1000MP Mark-V Field' then begin
         rig := TMARKVF.Create(1);
         rig._minband := b19;
         rig._maxband := b28;
      end;

      if rname = 'FT-1000' then begin
         rig := TFT1000.Create(1);
         rig._minband := b19;
         rig._maxband := b28;
      end;

      if rname = 'FT-920' then begin
         rig := TFT920.Create(1);
         rig._minband := b19;
         rig._maxband := b50;
      end;

      if rname = 'FT-100' then begin
         rig := TFT100.Create(1);
         rig._minband := b19;
         rig._maxband := b430;
      end;

      if rname = 'FT-847' then begin
         rig := TFT847.Create(1);
         rig._minband := b19;
         rig._maxband := b430;
      end;

      if rname = 'FT-817' then begin
         rig := TFT817.Create(1);
         rig._minband := b19;
         rig._maxband := b430;
      end;

      if rname = 'JST-145' then begin
         rig := TJST145.Create(1);
         rig._minband := b19;
         rig._maxband := b28;
      end;

      if rname = 'JST-245' then begin
         rig := TJST145.Create(1);
         rig._minband := b19;
         rig._maxband := b50;
      end;

      if pos('IC-', rname) = 1 then begin
         if (pos('IC-775', rname) = 1) or (pos('IC-756', rname) = 1) then begin
            rig := TIC756.Create(1);
         end
         else begin
            rig := TICOM.Create(1);
         end;

         for i := 1 to MAXICOM do begin
            if rname = ICOMLIST[i].name then begin
               break;
            end;
         end;

         rig._minband := ICOMLIST[i].minband;
         rig._maxband := ICOMLIST[i].maxband;
         rig.RigAddr := ICOMLIST[i].addr;
      end;

      rig.name := rname;
   end;
end;

procedure TRigControl.ImplementOptions;
begin
   BuildRigObject(Rig1);
   BuildRigObject(Rig2);

   case _currentrig of
      1:
         Rig := Rig1;
      2:
         Rig := Rig2;
      else
         Rig := nil;
   end;

   if Rig1 <> nil then begin
      if dmZlogGlobal.Settings._transverter1 then begin
         Rig1._freqoffset := 1000 * dmZlogGlobal.Settings._transverteroffset1;
      end
      else begin
         Rig1._freqoffset := 0;
      end;
   end;

   if Rig2 <> nil then begin
      if dmZlogGlobal.Settings._transverter2 then begin
         Rig2._freqoffset := 1000 * dmZlogGlobal.Settings._transverteroffset2;
      end
      else begin
         Rig2._freqoffset := 0;
      end;
   end;
end;

constructor TRig.Create(RigNum: Integer);
var
   B: TBand;
   M: TMode;
   prtnr: Integer;
begin
   // inherited
   for M := mCW to mOther do begin
      ModeWidth[M] := -1;
   end;

   FILO := False; // used for YAESU
   _freqoffset := 0;
   _minband := b19;
   _maxband := b10g;
   Name := '';
   _rignumber := RigNum;
   if _rignumber = 1 then begin
      prtnr := dmZlogGlobal.Settings._rig1port;
      Comm := RigControl.ZCom1;
   end
   else begin
      prtnr := dmZlogGlobal.Settings._rig2port;
      Comm := RigControl.ZCom2;
   end;
   Comm.Disconnect;
   Comm.Port := TPortNumber(prtnr);
   Comm.Connect;

   TerminatorCode := ';';
   BufferString := '';

   _currentmode := Main.CurrentQSO.QSO.Mode; // mCW;

   _currentband := b19;
   B := Main.CurrentQSO.QSO.Band;
   if (B >= _minband) and (B <= _maxband) then begin
      _currentband := B;
   end;

   _currentfreq[0] := 0;
   _currentfreq[1] := 0;
   _currentvfo := 0; // VFO A
   _lastcallsign := '';
   LastFreq := 0;

   // LastMode := mCW;
   for B := b19 to b10g do begin
      for M := mCW to mOther do begin
         FreqMem[B, M] := 0;
      end;
   end;
end;

destructor TRig.Destroy;
begin
   inherited;
end;

procedure TRig.VFOAEqualsB;
begin
end;

function TRig.CurrentFreqHz: LongInt;
begin
   Result := _currentfreq[_currentvfo] + _freqoffset;
end;

function TRig.CurrentFreqKHz: LongInt;
begin
   Result := (_currentfreq[_currentvfo] + _freqoffset) div 1000;
end;

function TRig.CurrentFreqkHzStr: string;
begin
   Result := IntToStr(CurrentFreqKHz);
end;

procedure TRig.PassOnRxData(S: string);
begin
   BufferString := BufferString + S;
   ParseBufferString;
end;

procedure TFT1000MP.PassOnRxData(S: string);
var
   i: Integer;
begin
   if FILO then begin
      for i := length(S) downto 1 do begin
         BufferString := S[i] + BufferString;
      end;
   end
   else begin
      BufferString := BufferString + S;
   end;

   ParseBufferString;
end;

procedure TRig.MoveToLastFreq;
begin
   SetFreq(LastFreq);
end;

constructor TTS690.Create(RigNum: Integer);
begin
   inherited;
   Comm.BaudRate := br4800;
   Comm.StopBits := sb2BITS;
   TerminatorCode := ';';
   _CWR := False;
   WriteData('AI1;');
end;

constructor TTS2000.Create(RigNum: Integer);
begin
   inherited;
   Comm.BaudRate := br9600;
   Comm.StopBits := sb1BITS;
   TerminatorCode := ';';
   WriteData('TC 1;');
   WriteData('AI2;');
   WriteData('IF;');
end;

constructor TTS2000P.Create(RigNum: Integer);
begin
   Inherited;
   RigControl.PallingTimer.Interval := 250;
   RigControl.PallingTimer.Enabled := True;
end;

constructor TJST145.Create(RigNum: Integer);
begin
   inherited;
   CommOn := 'H1' + _CR;
   CommOff := 'H0' + _CR;
   Comm.BaudRate := br4800;
   Comm.StopBits := sb1BITS;
   TerminatorCode := _CR;
   WriteData('I1' + _CR + 'L' + _CR);
end;

constructor TICOM.Create(RigNum: Integer);
begin
   inherited;

   case dmZlogGlobal.Settings._icombaudrate of
      0: Comm.BaudRate := br300;
      1: Comm.BaudRate := br1200;
      2: Comm.BaudRate := br2400;
      3: Comm.BaudRate := br4800;
      4: Comm.BaudRate := br9600;
      5: Comm.BaudRate := br19200;
      6: Comm.BaudRate := br38400;
      else Comm.BaudRate := br9600;
   end;

   Comm.StopBits := sb1BITS;
   TerminatorCode := Chr($FD);

   MyAddr := $E0;
   RigAddr := $01;
   SetVFO(0);
end;

procedure TICOM.ICOMWriteData(S: string);
begin
   WriteData(Chr($FE) + Chr($FE) + Chr(RigAddr) + Chr(MyAddr) + S + Chr($FD));
end;

constructor TFT1000MP.Create(RigNum: Integer);
begin
   inherited;
   WaitSize := 32;
   Comm.BaudRate := br4800;
   Comm.StopBits := sb2BITS;
   RigControl.PallingTimer.Interval := 250;
   RigControl.PallingTimer.Enabled := True;
end;

constructor TFT847.Create(RigNum: Integer);
begin
   inherited;
   WaitSize := 5;
   Comm.BaudRate := br4800;
   Comm.StopBits := sb2BITS;
   RigControl.PallingTimer.Interval := 250;
   RigControl.PallingTimer.Enabled := True;
   WriteData(Chr($00) + Chr($00) + Chr($00) + Chr($00) + Chr($00));
end;

constructor TFT920.Create(RigNum: Integer);
begin
   inherited;
   WaitSize := 28;
end;

constructor TFT100.Create(RigNum: Integer);
begin
   inherited;
   WaitSize := 32;
end;

destructor TTS690.Destroy;
begin
   WriteData('AI0;');
   inherited;
end;

destructor TJST145.Destroy;
begin
   WriteData(CommOff);
   RigControl.PallingTimer.Enabled := False;
   inherited;
end;

destructor TTS2000P.Destroy;
begin
   WriteData('AI0;');
   RigControl.PallingTimer.Enabled := False;
   inherited;
end;

destructor TICOM.Destroy;
begin
   inherited;
end;

destructor TFT1000MP.Destroy;
begin
   RigControl.PallingTimer.Enabled := False;
   inherited;
end;

destructor TFT847.Destroy;
begin
   WriteData(_nil4 + Chr($80));
   RigControl.PallingTimer.Enabled := False;
   inherited;
end;

procedure TTS690.ParseBufferString;
var
   i: Integer;
   temp: string;
begin
   i := pos(TerminatorCode, BufferString);
   while i > 0 do begin
      temp := copy(BufferString, 1, i);
      Delete(BufferString, 1, i);
      ExecuteCommand(temp);
      i := pos(TerminatorCode, BufferString);
   end;
end;

procedure TJST145.ParseBufferString; // cloned from TS690
var
   i: Integer;
   temp: string;
begin
   i := pos(TerminatorCode, BufferString);
   while i > 0 do begin
      temp := copy(BufferString, 1, i);
      Delete(BufferString, 1, i);
      ExecuteCommand(temp);
      i := pos(TerminatorCode, BufferString);
   end;
end;

procedure TJST145.RitClear();
begin
end;

function HexStr(S: string): string;
var
   i, j, k: Integer;
   ss: string;
   B: byte;
const
   _HEX: array [0 .. 15] of char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
begin
   ss := '';
   for i := 1 to length(S) do begin
      B := Ord(S[i]);
      j := B div 16;
      k := B mod 16;
      if (j < 16) and (k < 16) then
         ss := ss + '&' + _HEX[j] + _HEX[k]
      else
         ss := ss + '&xx';
   end;
   Result := ss;
end;

procedure TICOM.ParseBufferString; // same as ts690
var
   i: Integer;
   temp: string;
begin
   i := pos(TerminatorCode, BufferString);

   while i > 0 do begin
      temp := copy(BufferString, 1, i);
      Delete(BufferString, 1, i);

      ExecuteCommand(temp); // string formatted at excecutecommand
      i := pos(TerminatorCode, BufferString);
   end;
end;

function HexText(binstr: string): string;
var
   i, hex: Integer;
var
   x: string;
const
   hexarray = '0123456789ABCDEF';
begin
   x := '';
   for i := 1 to length(binstr) do begin
      hex := Ord(binstr[i]);
      x := x + '&' + hexarray[hex div 16 + 1] + hexarray[hex mod 16 + 1];
   end;
   Result := x;
end;

procedure TFT1000MP.PallingProcess;
begin
   WriteData(_nil3 + Chr($03) + Chr($10));
end;

procedure TFT847.PallingProcess;
begin
   WriteData(_nil4 + Chr($03));
end;

procedure TTS2000P.PallingProcess;
begin
   WriteData('IF;');
end;

procedure TJST145.PallingProcess;
begin
end;

procedure TFT1000MP.ParseBufferString;
var
   temp: string;
begin
   if length(BufferString) > 2048 then begin
      BufferString := '';
   end;

   if WaitSize = 0 then begin
      Exit;
   end;

   if length(BufferString) >= WaitSize then begin
      temp := copy(BufferString, 1, WaitSize);
      ExecuteCommand(temp);
      Delete(BufferString, 1, WaitSize);
   end;
end;

procedure TTS690.SetMode(Q: TQSO);
var
   Command: string;
   para: char;
begin
   { 1=LSB, 2=USB, 3=CW, 4=FM, 5=AM, 6=FSK, 7=CW-R, 8=FSK=R }
   para := '3';
   case Q.QSO.Mode of
      mSSB:
         if Q.QSO.Band <= b7 then
            para := '1'
         else
            para := '2';
      mCW:
         if _CWR then
            para := '7'
         else
            para := '3';
      mFM:
         para := '4';
      mAM:
         para := '5';
      mRTTY:
         para := '6';
   end;

   Command := 'MD' + para + TerminatorCode;
   WriteData(Command);
end;

procedure TJST145.SetMode(Q: TQSO);
var
   para: string;
begin
   para := '';
   case Q.QSO.Mode of
      mSSB:
         if Q.QSO.Band <= b7 then
            para := 'D3'
         else
            para := 'D2';
      mCW:
         para := 'D1';
      mFM:
         para := 'D5';
      mAM:
         para := 'D4';
      mRTTY:
         para := 'D9';
      else begin
            Exit;
         end;
   end;

   WriteData(CommOn + para + _CR + CommOff);
   WriteData('I1' + _CR);
end;

procedure TICOM.SetMode(Q: TQSO);
var
   Command: string;
   para: byte;
begin
   para := 3;
   case Q.QSO.Mode of
      mSSB:
         if Q.QSO.Band <= b7 then
            para := 0
         else
            para := 1;
      mCW:
         para := 3;
      mFM:
         para := 5;
      mAM:
         para := 2;
      mRTTY:
         para := 4;
   end;
   Command := Chr($06) + Chr(para);

   if ModeWidth[Q.QSO.Mode] in [1 .. 3] then begin
      Command := Command + Chr(ModeWidth[Q.QSO.Mode]);
   end;

   ICOMWriteData(Command);

   ICOMWriteData(Chr($04)); // request mode data
end;

procedure TFT1000MP.SetMode(Q: TQSO);
var
   Command: string;
   para: byte;
begin
   para := 0;

   case Q.QSO.Mode of
      mSSB:
         if Q.QSO.Band <= b7 then
            para := 0
         else
            para := 1;
      mCW:
         para := 2;
      mFM:
         para := 6;
      mAM:
         para := 4;
      mRTTY:
         para := 8;
      mOther:
         para := $0A;
   end;

   Command := _nil3 + Chr(para) + Chr($0C);
   WriteData(Command);
end;

procedure TRig.SetBand(Q: TQSO);
var
   f, ff: LongInt;
begin
   if (Q.QSO.Band < _minband) or (Q.QSO.Band > _maxband) then
      Exit;

   _currentband := Q.QSO.Band; // ver 2.0e

   if FreqMem[Q.QSO.Band, Q.QSO.Mode] > 0 then begin
      f := FreqMem[Q.QSO.Band, Q.QSO.Mode];
   end
   else begin
      ff := (_currentfreq[_currentvfo] + _freqoffset) mod 1000000;
      if ff > 500000 then
         ff := 0;
      f := BaseMHz[Q.QSO.Band] + ff;
   end;

   SetFreq(f);
   if Q.QSO.Mode = mSSB then begin
      Self.SetMode(Q);
   end;
end;

procedure TTS690.RitClear;
begin
   WriteData('RC;');
end;

procedure TICOM.RitClear;
begin
end;

procedure TFT1000MP.RitClear;
begin
   WriteData(_nil2 + Chr($0F) + Chr($0) + Chr($09));
end;

procedure TTS690.InquireStatus;
begin
   WriteData('IF;');
end;

procedure TJST145.InquireStatus;
begin
end;

procedure TICOM.InquireStatus;
begin
end;

procedure TFT1000MP.InquireStatus;
begin
end;

procedure TTS690.Reset;
begin
end;

procedure TJST145.Reset;
begin
   BufferString := '';
   WriteData('I1' + _CR + 'L' + _CR);
end;

procedure TICOM.Reset;
begin
end;

procedure TFT1000MP.Reset;
begin
   BufferString := '';
end;

procedure TTS690.SetFreq(Hz: LongInt);
var
   fstr: string;
begin
   LastFreq := _currentfreq[_currentvfo];
   fstr := IntToStr(Hz);
   while length(fstr) < 11 do begin
      fstr := '0' + fstr;
   end;

   if _currentvfo = 0 then
      WriteData('FA' + fstr + ';')
   else
      WriteData('FB' + fstr + ';');
end;

procedure TJST145.SetFreq(Hz: LongInt);
var
   fstr: string;
begin
   LastFreq := _currentfreq[_currentvfo];
   fstr := IntToStr(Hz);
   while length(fstr) < 8 do begin
      fstr := '0' + fstr;
   end;

   if _currentvfo = 0 then
      WriteData(CommOn + 'F' + fstr + 'A' + _CR + CommOff)
   else
      WriteData(CommOn + 'F' + fstr + 'B' + _CR + CommOff);
   WriteData('I1' + _CR);
end;

procedure TICOM.SetFreq(Hz: LongInt);
var
   fstr: string;
   freq, i: LongInt;
begin
   LastFreq := _currentfreq[_currentvfo];
   freq := Hz;

   if freq < 0 then // > 2.1GHz is divided by 100 and given a negative value. Not implemented yet
   begin
      fstr := Chr(0);
      freq := -1 * freq;
   end
   else begin
      i := freq mod 100;
      fstr := Chr((i div 10) * 16 + (i mod 10));
      freq := freq div 100;
   end;

   i := freq mod 100;
   fstr := fstr + Chr((i div 10) * 16 + (i mod 10));
   freq := freq div 100;

   i := freq mod 100;
   fstr := fstr + Chr((i div 10) * 16 + (i mod 10));
   freq := freq div 100;

   i := freq mod 100;
   fstr := fstr + Chr((i div 10) * 16 + (i mod 10));
   freq := freq div 100;

   if freq > 0 then begin
      i := freq mod 100;
      fstr := fstr + Chr((i div 10) * 16 + (i mod 10));
      // freq := freq div 100;
   end;

   fstr := Chr($05) + fstr;

   ICOMWriteData(fstr);

   fstr := Chr($03);
   ICOMWriteData(fstr); // request freq data
end;

procedure TRigControl.VisibleChangeEvent(Sender: TObject);
begin
end;

procedure TRigControl.RigTypeChangeEvent(Sender: TObject; RigNumber: Integer);
begin
end;

procedure TRigControl.StatusChangeEvent(Sender: TObject; RigNumber: Integer);
begin
end;

procedure TRigControl.ParamsChangeEvent(Sender: TObject; RigNumber: Integer; Params: Integer);
var
   j: Integer;
   o_RIG: IRigX;
   R: TRig;
begin
   if RigNumber = 1 then begin
      o_RIG := OmniRig.Rig1;
      R := Rig1;
   end
   else begin
      o_RIG := OmniRig.Rig2;
      R := Rig2;
   end;

   case o_RIG.Vfo of
      PM_VFOA:
         R._currentvfo := 0;
      PM_VFOB:
         R._currentvfo := 1;
   end;

   R._currentfreq[0] := o_RIG.FreqA;
   R._currentfreq[1] := o_RIG.FreqB;

   case o_RIG.Mode of
      PM_CW_U, PM_CW_L:
         R._currentmode := mCW;
      PM_SSB_U, PM_SSB_L:
         R._currentmode := mSSB;
      PM_DIG_U, PM_DIG_L:
         R._currentmode := mOther;
      PM_AM:
         R._currentmode := mAM;
      PM_FM:
         R._currentmode := mFM;
   end;

   if R._currentvfo = 0 then begin
      j := GetBand(R._currentfreq[0]);
      if j >= 0 then
         R._currentband := TBand(j);
      R.FreqMem[R._currentband, R._currentmode] := R._currentfreq[0];
   end;

   if R._currentvfo = 1 then begin
      j := GetBand(R._currentfreq[1]);
      if j >= 0 then
         R._currentband := TBand(j);
      R.FreqMem[R._currentband, R._currentmode] := R._currentfreq[1];
   end;

   if R.Selected then
      R.UpdateStatus;
end;

procedure TRigControl.CustomReplyEvent(Sender: TObject; RigNumber: Integer; Command, Reply: OleVariant);
begin
end;

constructor TOmni.Create(RigNum: Integer);
var
   M: TMode;
   B: TBand;
begin
   for M := mCW to mOther do begin
      ModeWidth[M] := -1;
   end;

   FILO := False; // used for YAESU
   _freqoffset := 0;
   _minband := b19;
   _maxband := b10g;
   Name := '';
   _rignumber := RigNum;
   TerminatorCode := ';';
   BufferString := '';

   _currentmode := Main.CurrentQSO.QSO.Mode; // mCW;

   _currentband := b19;
   B := Main.CurrentQSO.QSO.Band;
   if (B >= _minband) and (B <= _maxband) then
      _currentband := B;

   _currentfreq[0] := 0;
   _currentfreq[1] := 0;
   _currentvfo := 0; // VFO A
   _lastcallsign := '';
   LastFreq := 0;
   for B := b19 to b10g do begin
      for M := mCW to mOther do begin
         FreqMem[B, M] := 0;
      end;
   end;

   With RigControl do begin
      ZCom1.Disconnect;
      ZCom2.Disconnect;
      OmniRig.OnVisibleChange := VisibleChangeEvent;
      OmniRig.OnRigTypeChange := RigTypeChangeEvent;
      OmniRig.OnStatusChange := StatusChangeEvent;
      OmniRig.OnParamsChange := ParamsChangeEvent;
      OmniRig.OnCustomReply := CustomReplyEvent;
      OmniRig.Connect;
   end;

   if _rignumber = 1 then begin
      Self.name := 'Omni-Rig: ' + RigControl.OmniRig.Rig1.Get_RigType;
   end
   else begin
      Self.name := 'OMni-Rig: ' + RigControl.OmniRig.Rig2.Get_RigType;
   end;
end;

procedure TOmni.ExecuteCommand(S: string);
begin
end;

procedure TOmni.ParseBufferString;
begin
end;

procedure TOmni.RitClear;
begin
   if _rignumber = 1 then begin
      RigControl.OmniRig.Rig1.ClearRit;
   end
   else if _rignumber = 2 then begin
      RigControl.OmniRig.Rig2.ClearRit;
   end;
end;

procedure TOmni.SetFreq(Hz: LongInt);
var
   o_RIG: IRigX;
begin
   if _rignumber = 1 then begin
      o_RIG := RigControl.OmniRig.Rig1;
   end
   else begin
      o_RIG := RigControl.OmniRig.Rig2;
   end;

   LastFreq := _currentfreq[_currentvfo];

   if _currentvfo = 0 then
      o_RIG.FreqA := Hz
   else
      o_RIG.FreqB := Hz;
end;

procedure TOmni.SetMode(Q: TQSO);
var
   o_RIG: IRigX;
begin
   if _rignumber = 1 then begin
      o_RIG := RigControl.OmniRig.Rig1;
   end
   else begin
      o_RIG := RigControl.OmniRig.Rig2;
   end;

   case Q.QSO.Mode of
      mSSB:
         if Q.QSO.Band <= b7 then
            o_RIG.Mode := PM_SSB_L
         else
            o_RIG.Mode := PM_SSB_U;
      mCW:
         o_RIG.Mode := PM_CW_U;
      mFM:
         o_RIG.Mode := PM_FM;
      mAM:
         o_RIG.Mode := PM_AM;
      mRTTY:
         o_RIG.Mode := PM_DIG_L;
   end;
end;

procedure TOmni.SetVFO(i: Integer);
var
   o_RIG: IRigX;
begin
   if _rignumber = 1 then begin
      o_RIG := RigControl.OmniRig.Rig1;
   end
   else begin
      o_RIG := RigControl.OmniRig.Rig2;
   end;

   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;

   if i = 0 then
      o_RIG.Vfo := PM_VFOA
   else
      o_RIG.Vfo := PM_VFOB;

   if Selected then
      UpdateStatus;
end;

procedure TOmni.InquireStatus;
begin
   UpdateStatus;
end;

procedure TOmni.UpdateStatus;
var
   _rname: string;
begin
   inherited;
   if _rignumber = 1 then
      _rname := RigControl.OmniRig.Rig1.RigType
   else
      _rname := RigControl.OmniRig.Rig2.RigType;
   RigControl.RigLabel.Caption := 'Current rig : ' + IntToStr(RigControl._currentrig) + ' Omni-Rig: ' + _rname;
end;

procedure TOmni.Reset;
begin
end;

destructor TOmni.Destroy;
begin
   inherited;
end;

procedure TOmni.PassOnRxData(S: string);
begin
end;

function dec2hex(i: Integer): Integer;
begin
   if i < 10 then
      Result := i
   else begin
      Result := 16 * (i div 10) + (i mod 10);
   end;
end;

procedure TFT1000MP.SetFreq(Hz: LongInt);
var
   fstr: string;
   i, j: LongInt;
begin
   LastFreq := _currentfreq[_currentvfo];

   i := Hz;
   i := i div 10;

   j := i mod 100;
   fstr := Chr(dec2hex(j));
   i := i div 100;

   j := i mod 100;
   fstr := fstr + Chr(dec2hex(j));
   i := i div 100;

   j := i mod 100;
   fstr := fstr + Chr(dec2hex(j));
   i := i div 100;

   j := i mod 100;
   fstr := fstr + Chr(dec2hex(j));
   // i := i div 100;

   fstr := fstr + Chr($0A);

   WriteData(fstr);
end;

procedure TTS690.ExecuteCommand(S: string);
var
   Command: string;
   temp: string;
   i, j: LongInt;
   aa: Integer;
   M: TMode;
begin
   // RigControl.label1.caption := S;
   if length(S) < 2 then begin
      Exit;
   end;

   Command := S[1] + S[2];

   if (Command = 'FA') or (Command = 'FB') then begin
      if Command = 'FA' then
         aa := 0
      else
         aa := 1;

      temp := copy(S, 3, 11);
      i := StrToIntDef(temp, 0);
      _currentfreq[aa] := i;
      i := i + _freqoffset; // transverter

      if _currentvfo = aa then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];
      end;

      if Selected then
         UpdateStatus;
   end;

   if (Command = 'FT') or (Command = 'FR') then begin // 2.1j
      if S[3] = '0' then
         aa := 0
      else if S[3] = '1' then
         aa := 1
      else
         Exit;
      _currentvfo := aa;
      j := GetBand(_currentfreq[aa]);
      if j >= 0 then
         _currentband := TBand(j);
      FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];
      if Selected then
         UpdateStatus;
   end;

   if Command = 'IF' then begin
      if length(S) < 38 then
         Exit;

      case S[31] of
         '0':
            _currentvfo := 0;
         '1':
            _currentvfo := 1;
         // '2' : memory
      end;

      temp := copy(S, 3, 11);
      i := StrToIntDef(temp, 0);
      _currentfreq[_currentvfo] := i;
      i := i + _freqoffset; // transverter

      j := GetBand(i);
      if j >= 0 then begin
         _currentband := TBand(j);
      end;

      temp := copy(S, 30, 1);
      case S[30] of
         '1', '2':
            M := mSSB;
         '3': begin
               M := mCW;
               _CWR := False;
            end;
         '7': begin
               M := mCW;
               _CWR := True;
            end;
         '4':
            M := mFM;
         '5':
            M := mAM;
         '6', '8':
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];

      if Selected then
         UpdateStatus;

   end;

   if Command = 'MD' then begin
      case S[3] of
         '1', '2':
            M := mSSB;
         '3': begin
               M := mCW;
               _CWR := False;
            end;
         '7': begin
               M := mCW;
               _CWR := True;
            end;
         '4':
            M := mFM;
         '5':
            M := mAM;
         '6', '8':
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;
      FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];
      if Selected then
         UpdateStatus;
   end;

end;

procedure TJST145.ExecuteCommand(S: string);
var
   Command: string;
   temp: string;
   i, j: LongInt;
   aa: Integer;
   // B : TBand;
   M: TMode;
   ss: string;
begin
   // RigControl.label1.caption := S;
   if length(S) < 10 then
      Exit;
   Command := S[1] + S[2];
   if S[1] = 'I' then
      Command := 'I';
   if (Command = 'LA') or (Command = 'LB') or (Command = 'I') then begin
      ss := S;
      Delete(ss, 1, length(Command));
      if Command = 'LA' then
         aa := 0
      else
         aa := 1;
      if Command = 'I' then
         aa := _currentvfo;

      temp := copy(ss, 4, 8);
      i := StrToIntDef(temp, 0);
      _currentfreq[aa] := i;
      i := i + _freqoffset;

      if _currentvfo = aa then begin
         case ss[3] of
            '2', '3':
               M := mSSB;
            '1':
               M := mCW;
            '5':
               M := mFM;
            '4':
               M := mAM;
            '0':
               M := mRTTY;
            else
               M := mOther;
         end;
         _currentmode := M;
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];
      end;

      if Selected then
         UpdateStatus;
   end;
end;

procedure TICOM.ExecuteCommand(S: string);
var
   Command: byte;
   temp: byte;
   i, j, i1, i2, i3, i4, i5: LongInt;
   // aa : integer;
   // B : TBand;
   M: TMode;
   ss: string;
begin
   // RigControl.label1.caption := S;
   ss := S;
   i := pos(Chr($FE) + Chr($FE), ss);

   if i = 0 then begin
      Exit;
   end;

   if i > 1 then begin
      Delete(ss, 1, i - 1);
   end;

   if length(ss) < 6 then begin
      Exit;
   end;

   if not(Ord(ss[3]) in [0, MyAddr]) then begin
      Exit;
   end;

   if ss[4] <> Chr(RigAddr) then begin
      Exit;
   end;

   Delete(ss, 1, 4);
   Delete(ss, length(ss), 1);

   Command := Ord(ss[1]);

   if length(ss) = 1 then begin
      case Command of
         $FA:
            Exit; // ng message
         $FB:
            Exit; // ok message
      end;
      Exit;
   end;

   case Command of
      $01, $04: begin
         temp := Ord(ss[2]);
         case temp of
            0, 1:
               M := mSSB;
            3:
               M := mCW;
            5, 6:
               M := mFM;
            2:
               M := mAM;
            4:
               M := mRTTY;
            else
               M := mOther;
         end;
         _currentmode := M;

         if length(ss) >= 3 then begin
            if Ord(ss[3]) in [1 .. 3] then begin
               ModeWidth[M] := Ord(ss[3]); // IF width
            end;
         end;

         FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];
         if Selected then begin
            UpdateStatus;
         end;
      end;

      $00, $03: begin
         if length(ss) < 4 then begin
            Exit;
         end;

         Delete(ss, 1, 1);
         i1 := (Ord(ss[1]) mod 16) + (Ord(ss[1]) div 16) * 10;
         i2 := (Ord(ss[2]) mod 16) + (Ord(ss[2]) div 16) * 10;
         i3 := (Ord(ss[3]) mod 16) + (Ord(ss[3]) div 16) * 10;
         i4 := (Ord(ss[4]) mod 16) + (Ord(ss[4]) div 16) * 10;

         if length(ss) = 5 then begin
            i5 := (Ord(ss[5]) mod 16) + (Ord(ss[5]) div 16) * 10;
         end
         else begin
            i5 := 0;
         end;

         i := i1 + 100 * i2 + 10000 * i3 + 1000000 * i4 + 100000000 * i5;
         _currentfreq[_currentvfo] := i;
         i := i + _freqoffset;

         j := GetBand(i);
         if j >= 0 then begin
            _currentband := TBand(j);
         end;

         FreqMem[_currentband, _currentmode] := _currentfreq[_currentvfo];
         if Selected then begin
            UpdateStatus;
         end;
      end;
   end;
end;

function hex2dec(i: Integer): Integer;
begin
   Result := (i div 16) * 10 + (i mod 16);
end;

procedure TFT100.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = WaitSize then begin
      case Ord(S[6]) and $7 of
         0, 1:
            M := mSSB;
         2, 3:
            M := mCW;
         4:
            M := mAM;
         6, 7:
            M := mFM;
         5:
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := Ord(S[2]) * 256 * 256 * 256 + Ord(S[3]) * 256 * 256 + Ord(S[4]) * 256 + Ord(S[5]);
      i := round(i * 1.25);
      _currentfreq[0] := i;
      i := Ord(S[18]) * 256 * 256 * 256 + Ord(S[19]) * 256 * 256 + Ord(S[20]) * 256 + Ord(S[21]);
      i := round(i * 1.25);
      _currentfreq[1] := i;

      i := _currentfreq[_currentvfo] + _freqoffset;

      j := GetBand(i);
      if j >= 0 then begin
         _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0];
      end;

   end;
   if Selected then
      UpdateStatus;
end;

procedure TFT100.SetVFO(i: Integer); // A:0, B:1
begin
   if (i > 1) or (i < 0) then begin
      Exit;
   end;

   _currentvfo := i;
   if i = 0 then
      WriteData(_nil3 + Chr(0) + Chr($05))
   else
      WriteData(_nil3 + Chr(1) + Chr($05));
   if Selected then
      UpdateStatus;
end;

procedure TFT100.RitClear;
begin
end;

procedure TFT920.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = 28 then begin
      if _currentvfo = 0 then
         i := Ord(S[8])
      else
         i := Ord(S[8 + 14]);

      case i and $07 of
         0:
            M := mSSB;
         1:
            M := mCW;
         2:
            M := mAM;
         3:
            M := mFM;
         4, 5:
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := Ord(S[2]) * 256 * 256 * 256 + Ord(S[3]) * 256 * 256 + Ord(S[4]) * 256 + Ord(S[5]);
      // i := round(i / 1.60);
      _currentfreq[0] := i;
      i := i + _freqoffset;

      if _currentvfo = 0 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0]; // i;
      end;

      i := Ord(S[16]) * 256 * 256 * 256 + Ord(S[17]) * 256 * 256 + Ord(S[18]) * 256 + Ord(S[19]);
      // i := round(i / 1.60);
      _currentfreq[1] := i;
      i := i + _freqoffset;

      if _currentvfo = 1 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[1]; // i;
      end;

   end;

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TFT1000MP.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = 32 then begin
      if _currentvfo = 0 then
         i := Ord(S[8])
      else
         i := Ord(S[8 + 16]);

      case i of
         0, 1:
            M := mSSB;
         2:
            M := mCW;
         3:
            M := mAM;
         4:
            M := mFM;
         5:
            M := mRTTY;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := Ord(S[2]) * 256 * 256 * 256 + Ord(S[3]) * 256 * 256 + Ord(S[4]) * 256 + Ord(S[5]);
      i := round(i / 1.60);
      _currentfreq[0] := i;
      i := i + _freqoffset;

      if _currentvfo = 0 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0];
      end;

      i := Ord(S[18]) * 256 * 256 * 256 + Ord(S[19]) * 256 * 256 + Ord(S[20]) * 256 + Ord(S[21]);
      i := round(i / 1.60);
      _currentfreq[1] := i;
      i := i + _freqoffset;

      if _currentvfo = 1 then begin
         j := GetBand(i);
         if j >= 0 then
            _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[1];
      end;

   end;

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TFT847.ExecuteCommand(S: string);
var
   i, j: LongInt;
   M: TMode;
begin
   if length(S) = WaitSize then begin
      case Ord(S[5]) mod 16 of // ord(S[5]) and $7?
         0, 1:
            M := mSSB;
         2, 3:
            M := mCW;
         4:
            M := mAM;
         8:
            M := mFM;
         else
            M := mOther;
      end;
      _currentmode := M;

      i := (Ord(S[1]) div 16) * 100000000 + (Ord(S[1]) mod 16) * 10000000 + (Ord(S[2]) div 16) * 1000000 + (Ord(S[2]) mod 16) * 100000 +
        (Ord(S[3]) div 16) * 10000 + (Ord(S[3]) mod 16) * 1000 + (Ord(S[4]) div 16) * 100 + (Ord(S[4]) mod 16) * 10;
      _currentfreq[_currentvfo] := i;
      i := i + _freqoffset;

      j := GetBand(i);
      if j >= 0 then begin
         _currentband := TBand(j);
         FreqMem[_currentband, _currentmode] := _currentfreq[0];
      end;

   end;

   if Selected then begin
      UpdateStatus;
   end;
end;

procedure TFT847.RitClear;
begin
end;

procedure TFT847.SetVFO(i: Integer);
begin
end;

procedure TFT847.SetFreq(Hz: LongInt);
var
   fstr: string;
   i, j: LongInt;
begin
   LastFreq := _currentfreq[_currentvfo];

   i := Hz;
   i := i div 10;

   j := i mod 100;
   fstr := Chr(dec2hex(j));
   i := i div 100;

   j := i mod 100;
   fstr := Chr(dec2hex(j)) + fstr;
   i := i div 100;

   j := i mod 100;
   fstr := Chr(dec2hex(j)) + fstr;
   i := i div 100;

   j := i mod 100;
   fstr := Chr(dec2hex(j)) + fstr;
   // i := i div 100;

   fstr := fstr + Chr($01);

   WriteData(fstr);
end;

procedure TFT847.SetMode(Q: TQSO);
var
   Command: string;
   para: byte;
begin
   case Q.QSO.Mode of
      mSSB:
         if Q.QSO.Band <= b7 then
            para := 0
         else
            para := 1;
      mCW:
         para := 2;
      mFM:
         para := 8;
      mAM:
         para := 4;
      else
         para := 0;
   end;

   Command := Chr(para) + _nil3 + Chr($07);
   WriteData(Command);
end;

procedure TFT817.SetFreq(Hz: LongInt);
var
   StartTime: TDateTime;
begin
   RigControl.PallingTimer.Enabled := False;
   BufferString := '';
   inherited;
   StartTime := Now;
   repeat
      SleepEx(10, False)
   until (BufferString <> '') or ((Now - StartTime) > (250 / (24 * 60 * 60 * 1000)));
   BufferString := '';
   RigControl.PallingTimer.Enabled := True;
end;

procedure TFT817.SetMode(Q: TQSO);
var
   StartTime: TDateTime;
begin
   RigControl.PallingTimer.Enabled := False;
   BufferString := '';
   inherited;
   StartTime := Now;
   repeat
      SleepEx(10, False)
   until (BufferString <> '') or ((Now - StartTime) > (250 / (24 * 60 * 60 * 1000)));
   BufferString := '';
   RigControl.PallingTimer.Enabled := True;
end;

procedure TRig.UpdateStatus;
var
   S: string;
begin
   RigControl.dispVFO.Caption := VFOString[_currentvfo];
   if _currentmode <> Main.CurrentQSO.QSO.Mode then begin
      MainForm.UpdateMode(_currentmode);
   end;

   RigControl.dispMode.Caption := ModeString[_currentmode];
   if Main.CurrentQSO.QSO.Band <> _currentband then begin
      MainForm.UpdateBand(_currentband);
   end;

   RigControl.dispFreqA.Caption := kHzStr(_freqoffset + _currentfreq[0]) + ' kHz';
   RigControl.dispFreqB.Caption := kHzStr(_freqoffset + _currentfreq[1]) + ' kHz';

   if _currentvfo = 0 then begin
      RigControl.dispFreqA.Font.Style := [fsBold];
      RigControl.dispFreqB.Font.Style := [];
   end
   else begin
      RigControl.dispFreqB.Font.Style := [fsBold];
      RigControl.dispFreqA.Font.Style := [];
   end;

   S := 'R' + IntToStr(_rignumber) + ' ' + 'V';
   if _currentvfo = 0 then begin
      S := S + 'A';
   end
   else begin
      S := S + 'B';
   end;

   MainForm.StatusLine.Panels[1].Text := S;

   BSRefresh(Self);
   BandScope2.MarkCurrentFreq(_freqoffset + _currentfreq[_currentvfo]);
end;

procedure TRigControl.FormCreate(Sender: TObject);
var
   i: Integer;
   B: TBand;
begin
   RigLabel.Caption := '';
   Rig := nil;
   Rig1 := nil;
   Rig2 := nil;
   _currentrig := 1;
   _maxrig := 2;

   for B := b19 to HiBand do begin
      TempFreq[B] := 0;
   end;

   for i := 1 to MAXVIRTUALRIG do begin
      VirtualRig[i].Callsign := '';
      VirtualRig[i].Band := b19;
      VirtualRig[i].Mode := mCW;
      VirtualRig[i].FirstTime := True;
   end;

   OmniRig := TOmniRigX.Create(Self);
end;

procedure TRigControl.FormDestroy(Sender: TObject);
begin
   ZCom1.Disconnect;
   ZCom1.Free;
   ZCom2.Disconnect;
   ZCom2.Free;
   ZCom3.Disconnect;
   ZCom3.Free;

   Rig := nil;
   if Rig1 <> nil then begin
      Rig1.Free;
   end;

   if Rig2 <> nil then begin
      Rig2.Free;
   end;
end;

procedure TRigControl.Button1Click(Sender: TObject);
begin
   if RigControl.Rig <> nil then begin
      RigControl.Rig.Reset;
   end;
end;

procedure TRigControl.Timer1Timer(Sender: TObject);
begin
   ZLinkForm.SendRigStatus;
end;

procedure TRigControl.PallingTimerTimer(Sender: TObject);
begin
   if Rig <> nil then begin
      Rig.PallingProcess;
   end;
end;

procedure TRigControl.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
      VK_ESCAPE:
         MainForm.LastFocus.SetFocus;
   end;
end;

procedure TRigControl.ZCom1ReceiveData(Sender: TObject; DataPtr: Pointer; DataSize: Cardinal);
var
   str: string;
begin
   // Convert incoming data into a string
   str := StringOfChar(' ', DataSize);
   move(DataPtr^, pchar(str)^, DataSize);

   if TCommPortDriver(Sender).Tag = 1 then begin
      Rig1.PassOnRxData(str);
   end
   else begin
      Rig2.PassOnRxData(str);
   end;
end;

procedure TRigControl.btnOmniRigClick(Sender: TObject);
begin
   RigControl.OmniRig.DialogVisible := True;
end;

end.
