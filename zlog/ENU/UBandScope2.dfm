object BandScope2: TBandScope2
  Left = 48
  Top = 125
  BorderStyle = bsSizeToolWin
  Caption = 'Band Scope'
  ClientHeight = 416
  ClientWidth = 234
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 250
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 38
    Width = 234
    Height = 378
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    BorderStyle = bsSingle
    Color = clRed
    ParentBackground = False
    TabOrder = 0
    object Grid: TStringGrid
      Left = 4
      Top = 4
      Width = 222
      Height = 366
      Align = alClient
      ColCount = 1
      DefaultColWidth = 188
      DefaultDrawing = False
      DoubleBuffered = True
      FixedCols = 0
      FixedRows = 0
      Options = []
      ParentDoubleBuffered = False
      ParentShowHint = False
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
      OnContextPopup = GridContextPopup
      OnDblClick = GridDblClick
      OnDrawCell = GridDrawCell
      OnMouseMove = GridMouseMove
      OnMouseWheelDown = GridMouseWheelDown
      OnMouseWheelUp = GridMouseWheelUp
    end
  end
  object panelStandardOption: TPanel
    Left = 0
    Top = 0
    Width = 234
    Height = 19
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      234
      19)
    object buttonShowWorked: TSpeedButton
      Left = 174
      Top = 0
      Width = 60
      Height = 19
      Hint = 'Show worked'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 1
      Caption = 'WORKED'
      ParentShowHint = False
      ShowHint = True
      OnClick = buttonShowWorkedClick
    end
    object buttonShowAllBands: TSpeedButton
      Left = 115
      Top = 0
      Width = 60
      Height = 19
      Hint = 'Show all bands'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 2
      Caption = 'ALL'
      ParentShowHint = False
      ShowHint = True
      OnClick = buttonShowWorkedClick
    end
    object buttonSyncVfo: TSpeedButton
      Left = 4
      Top = 0
      Width = 53
      Height = 19
      Hint = 'Synchronize frequency to VFO'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 4
      Caption = 'S.VFO'
      ParentShowHint = False
      ShowHint = True
      OnClick = buttonShowWorkedClick
    end
    object buttonFreqCenter: TSpeedButton
      Left = 56
      Top = 0
      Width = 60
      Height = 19
      Hint = 'Fixed frequency display in the center'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 5
      Caption = 'F.CENTER'
      ParentShowHint = False
      ShowHint = True
      OnClick = buttonShowWorkedClick
    end
  end
  object panelAllBandsOption: TPanel
    Left = 0
    Top = 19
    Width = 234
    Height = 19
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    Visible = False
    DesignSize = (
      234
      19)
    object buttonShowWorked2: TSpeedButton
      Left = 174
      Top = 0
      Width = 60
      Height = 19
      Hint = 'Show worked'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 3
      Caption = 'WORKED'
      ParentShowHint = False
      ShowHint = True
      OnClick = buttonShowWorkedClick
    end
    object buttonSortByFreq: TSpeedButton
      Left = 4
      Top = 0
      Width = 60
      Height = 19
      Anchors = [akTop, akRight]
      Caption = 'freq.'
      Images = ImageList2
      OnClick = buttonSortByFreqClick
    end
    object buttonSortByTime: TSpeedButton
      Left = 63
      Top = 0
      Width = 60
      Height = 19
      Anchors = [akTop, akRight]
      Caption = 'time'
      Images = ImageList2
      OnClick = buttonSortByTimeClick
    end
  end
  object BSMenu: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    AutoPopup = False
    Left = 48
    Top = 48
    object menuDeleteSpot: TMenuItem
      Caption = 'Delete'
      OnClick = menuDeleteSpotClick
    end
    object menuDeleteAllWorkedStations: TMenuItem
      Caption = 'Delete all worked stations'
      OnClick = menuDeleteAllWorkedStationsClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object menuAddToDenyList: TMenuItem
      Caption = 'Add this reporter to deny list'
      OnClick = menuAddToDenyListClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 56
    Top = 112
  end
  object ImageList1: TImageList
    Left = 56
    Top = 176
  end
  object timerCleanup: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = timerCleanupTimer
    Left = 112
    Top = 136
  end
  object ActionList1: TActionList
    State = asSuspended
    Left = 118
    Top = 68
    object actionPlayMessageA01: TAction
      Tag = 1
      Caption = 'actionPlayMessageA01'
      ShortCut = 112
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA02: TAction
      Tag = 2
      Caption = 'actionPlayMessageA02'
      ShortCut = 113
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA03: TAction
      Tag = 3
      Caption = 'actionPlayMessageA03'
      ShortCut = 114
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA04: TAction
      Tag = 4
      Caption = 'actionPlayMessageA04'
      ShortCut = 115
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA05: TAction
      Tag = 5
      Caption = 'actionPlayMessageA05'
      ShortCut = 116
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA06: TAction
      Tag = 6
      Caption = 'actionPlayMessageA06'
      ShortCut = 117
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA07: TAction
      Tag = 7
      Caption = 'actionPlayMessageA07'
      ShortCut = 118
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA08: TAction
      Tag = 8
      Caption = 'actionPlayMessageA08'
      ShortCut = 119
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA09: TAction
      Tag = 9
      Caption = 'actionPlayMessageA09'
      ShortCut = 120
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA10: TAction
      Tag = 10
      Caption = 'actionPlayMessageA10'
      ShortCut = 121
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA11: TAction
      Tag = 11
      Caption = 'actionPlayMessageA11'
      ShortCut = 122
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageA12: TAction
      Tag = 12
      Caption = 'actionPlayMessageA12'
      ShortCut = 123
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayMessageB01: TAction
      Tag = 1
      Caption = 'actionPlayMessageB01'
      ShortCut = 8304
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB02: TAction
      Tag = 2
      Caption = 'actionPlayMessageB02'
      ShortCut = 8305
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB03: TAction
      Tag = 3
      Caption = 'actionPlayMessageB03'
      ShortCut = 8306
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB04: TAction
      Tag = 4
      Caption = 'actionPlayMessageB04'
      ShortCut = 8307
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB05: TAction
      Tag = 5
      Caption = 'actionPlayMessageB05'
      ShortCut = 8308
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB06: TAction
      Tag = 6
      Caption = 'actionPlayMessageB06'
      ShortCut = 8309
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB07: TAction
      Tag = 7
      Caption = 'actionPlayMessageB07'
      ShortCut = 8310
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB08: TAction
      Tag = 8
      Caption = 'actionPlayMessageB08'
      ShortCut = 8311
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB09: TAction
      Tag = 9
      Caption = 'actionPlayMessageB09'
      ShortCut = 8312
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB10: TAction
      Tag = 10
      Caption = 'actionPlayMessageB10'
      ShortCut = 8313
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB11: TAction
      Tag = 11
      Caption = 'actionPlayMessageB11'
      ShortCut = 8314
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayMessageB12: TAction
      Tag = 12
      Caption = 'actionPlayMessageB12'
      ShortCut = 8315
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayCQA1: TAction
      Tag = 101
      Caption = 'actionPlayCQA1'
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayCQA2: TAction
      Tag = 102
      Caption = 'actionPlayCQA2'
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayCQA3: TAction
      Tag = 103
      Caption = 'actionPlayCQA3'
      OnExecute = actionPlayMessageAExecute
    end
    object actionPlayCQB1: TAction
      Tag = 101
      Caption = 'actionPlayCQB1'
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayCQB2: TAction
      Tag = 102
      Caption = 'actionPlayCQB2'
      OnExecute = actionPlayMessageBExecute
    end
    object actionPlayCQB3: TAction
      Tag = 103
      Caption = 'actionPlayCQB3'
      OnExecute = actionPlayMessageBExecute
    end
    object actionDecreaseCwSpeed: TAction
      Caption = 'actionDecreaseCwSpeed'
      ShortCut = 8277
      OnExecute = actionDecreaseCwSpeedExecute
    end
    object actionIncreaseCwSpeed: TAction
      Caption = 'actionIncreaseCwSpeed'
      ShortCut = 8281
      OnExecute = actionIncreaseCwSpeedExecute
    end
  end
  object ImageList2: TImageList
    Left = 56
    Top = 236
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      F00FFE7F00000000F81FFC3F00000000FC3FF81F00000000FE7FF00F00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end
