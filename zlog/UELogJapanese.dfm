object formELogJarl: TformELogJarl
  Left = 103
  Top = 10
  Caption = 'E-Log (Japanese)'
  ClientHeight = 602
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    506
    602)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 23
    Top = 17
    Width = 86
    Height = 12
    Caption = #12467#12531#12486#12473#12488#12398#21517#31216
  end
  object Label2: TLabel
    Left = 23
    Top = 41
    Width = 78
    Height = 12
    Caption = #21442#21152#31278#30446#12467#12540#12489
  end
  object Label4: TLabel
    Left = 23
    Top = 65
    Width = 66
    Height = 12
    Caption = #12467#12540#12523#12469#12452#12531
  end
  object Label5: TLabel
    Left = 23
    Top = 89
    Width = 293
    Height = 12
    Caption = #36939#29992#32773#12398#12467#12540#12523#12469#12452#12531#65288#12471#12531#12464#12523#12458#12506#12391#19978#35352#12392#30064#12394#12427#22580#21512#65289
  end
  object Label6: TLabel
    Left = 23
    Top = 111
    Width = 132
    Height = 12
    Caption = #23616#31278#20418#25968'('#12501#12451#12540#12523#12489#12487#12540#65289
  end
  object Label7: TLabel
    Left = 23
    Top = 131
    Width = 120
    Height = 12
    Caption = #36899#32097#20808#20303#25152#12288#65288'5'#34892#12414#12391#65289
  end
  object Label8: TLabel
    Left = 23
    Top = 203
    Width = 48
    Height = 12
    Caption = #38651#35441#30058#21495
  end
  object Label9: TLabel
    Left = 23
    Top = 230
    Width = 152
    Height = 12
    Caption = #23616#20813#35377#32773#12398#27663#21517'('#31038#22243#12398#21517#31216')'
  end
  object Label10: TLabel
    Left = 23
    Top = 257
    Width = 74
    Height = 12
    Caption = 'E-mail'#12450#12489#12524#12473
  end
  object Label13: TLabel
    Left = 23
    Top = 318
    Width = 36
    Height = 12
    Caption = #36939#29992#22320
  end
  object Label14: TLabel
    Left = 23
    Top = 284
    Width = 207
    Height = 12
    Caption = #12467#12531#12486#12473#12488#20013#20351#29992#12375#12383#26368#22823#31354#20013#32218#38651#21147'(W)'
  end
  object Label15: TLabel
    Left = 280
    Top = 318
    Width = 68
    Height = 12
    Caption = #20351#29992#12375#12383#38651#28304
  end
  object Label16: TLabel
    Left = 23
    Top = 348
    Width = 82
    Height = 12
    Caption = #24847#35211#65288'10'#34892#12414#12391#65289
  end
  object Label17: TLabel
    Left = 23
    Top = 390
    Width = 448
    Height = 12
    Caption = #12510#12523#12481#12458#12506#12289#12466#12473#12488#12458#12506#12398#22580#21512#12398#36939#29992#32773#12398#12467#12540#12523#12469#12452#12531#65288#27663#21517#65289#12362#12424#12403#28961#32218#24467#20107#32773#12398#36039#26684' '
  end
  object Label18: TLabel
    Left = 23
    Top = 421
    Width = 79
    Height = 12
    Caption = #30331#37682#12463#12521#12502#30058#21495
  end
  object Label20: TLabel
    Left = 23
    Top = 454
    Width = 36
    Height = 12
    Caption = #23459#35475#25991
  end
  object Label21: TLabel
    Left = 23
    Top = 534
    Width = 24
    Height = 12
    Caption = #26085#20184
  end
  object Label23: TLabel
    Left = 284
    Top = 531
    Width = 24
    Height = 12
    Caption = #32626#21517
  end
  object mOath: TMemo
    Left = 23
    Top = 470
    Width = 465
    Height = 47
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    Lines.Strings = (
      #31169#12399#12289'JARL'#21046#23450#12398#12467#12531#12486#12473#12488#35215#32004#12362#12424#12403#38651#27874#27861#20196#12395#12375#12383#12364#12356#36939#29992#12375#12383#32080#26524#12289#12371#12371
      #12395#25552#20986#12377#12427#12469#12510#12522#12540#12471#12540#12488#12362#12424#12403#12525#12464#12471#12540#12488#12394#12393#12364#20107#23455#12392#30456#36949#12394#12356#12418#12398#12391#12354#12427#12371#12392
      #12434
      #12289#31169#12398#21517#35465#12395#12362#12356#12390#35475#12356#12414#12377#12290)
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 14
  end
  object edContestName: TEdit
    Left = 115
    Top = 13
    Width = 373
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = #12467#12531#12486#12473#12488
  end
  object edCallsign: TEdit
    Left = 115
    Top = 61
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = #12467#12531#12486#12473#12488
  end
  object edOpCallsign: TEdit
    Left = 367
    Top = 85
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = #12467#12531#12486#12473#12488
  end
  object edCategoryCode: TEdit
    Left = 115
    Top = 37
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = #12467#12531#12486#12473#12488
  end
  object edFDCoefficient: TEdit
    Left = 163
    Top = 107
    Width = 45
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = #12467#12531#12486#12473#12488
  end
  object edTEL: TEdit
    Left = 115
    Top = 199
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = #12467#12531#12486#12473#12488
  end
  object edOPName: TEdit
    Left = 179
    Top = 226
    Width = 301
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = #12467#12531#12486#12473#12488
  end
  object edEMail: TEdit
    Left = 115
    Top = 253
    Width = 253
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = #12467#12531#12486#12473#12488
  end
  object edPower: TEdit
    Left = 243
    Top = 280
    Width = 125
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    Text = #12467#12531#12486#12473#12488
  end
  object edQTH: TEdit
    Left = 115
    Top = 314
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    Text = #12467#12531#12486#12473#12488
  end
  object edClubID: TEdit
    Left = 115
    Top = 417
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    Text = #12467#12531#12486#12473#12488
  end
  object edPowerSupply: TEdit
    Left = 372
    Top = 314
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    Text = #12467#12531#12486#12473#12488
  end
  object mComments: TMemo
    Left = 23
    Top = 364
    Width = 465
    Height = 47
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object edDate: TEdit
    Left = 107
    Top = 528
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    Text = #12467#12531#12486#12473#12488
  end
  object edSignature: TEdit
    Left = 368
    Top = 528
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 16
  end
  object buttonCreateLog: TButton
    Left = 208
    Top = 571
    Width = 89
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'E-log'#20316#25104
    TabOrder = 18
    OnClick = buttonCreateLogClick
  end
  object buttonSave: TButton
    Left = 104
    Top = 571
    Width = 89
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = #20445#23384
    TabOrder = 17
    OnClick = buttonSaveClick
  end
  object buttonCancel: TButton
    Left = 312
    Top = 571
    Width = 89
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = #38281#12376#12427
    ModalResult = 2
    TabOrder = 19
    OnClick = buttonCancelClick
  end
  object mAddress: TMemo
    Left = 23
    Top = 147
    Width = 465
    Height = 47
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    MaxLength = 400
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'em'
    Filter = 'JARL E-log files (*.em)|*.em|'#20840#12390#12398#12501#12449#12452#12523'|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save E-Log file'
    Left = 16
    Top = 560
  end
end
