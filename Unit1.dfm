object Form1: TForm1
  Left = 342
  Top = 110
  Caption = 'Form1'
  ClientHeight = 567
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 129
    Height = 24
    Caption = #1050#1086#1083'-'#1074#1086' '#1083#1091#1095#1077#1081':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 79
    Width = 182
    Height = 24
    Caption = #1057#1074#1077#1090#1086#1074#1086#1081' '#1087#1086#1090#1086#1082' '#1057#1044':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Gauge1: TGauge
    Left = 8
    Top = 375
    Width = 296
    Height = 45
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Progress = 0
  end
  object Label3: TLabel
    Left = 294
    Top = 366
    Width = 6
    Height = 23
    Caption = ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 277
    Width = 43
    Height = 25
    Caption = 'Alfa:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 346
    Width = 207
    Height = 23
    Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1083#1091#1095#1077#1081', % :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 128
    Top = 285
    Width = 40
    Height = 23
    Caption = #1050#1057#1057':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  inline Frame21: TFrame2
    Left = 320
    Top = 31
    Width = 500
    Height = 500
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Frame21Click
    ExplicitLeft = 320
    ExplicitTop = 31
    ExplicitWidth = 500
    ExplicitHeight = 500
  end
  object btTrassirovka: TButton
    Left = 8
    Top = 188
    Width = 193
    Height = 49
    Caption = #1058#1088#1072#1089#1089#1080#1088#1086#1074#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 28
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btTrassirovkaClick
  end
  object _Luch: TButton
    Left = 422
    Top = 208
    Width = 275
    Height = 40
    Caption = '_Luch'
    TabOrder = 2
    OnClick = _LuchClick
  end
  object Edit1: TEdit
    Left = 143
    Top = 146
    Width = 161
    Height = 36
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 28
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = '100000'
  end
  object Edit2: TEdit
    Left = 188
    Top = 76
    Width = 108
    Height = 32
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = '1000'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 109
    Width = 160
    Height = 17
    Caption = #1053#1072' '#1082#1072#1078#1076#1099#1081' '#1057#1044
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 243
    Width = 161
    Height = 17
    Caption = #1056#1072#1089#1095#1105#1090' '#1089' '#1082#1086#1088#1087#1091#1089#1086#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object _KSS: TButton
    Left = 136
    Top = 683
    Width = 41
    Height = 23
    Caption = #1050#1057#1057
    TabOrder = 7
    Visible = False
    OnClick = _KSSClick
  end
  object Edit3: TEdit
    Left = 57
    Top = 276
    Width = 45
    Height = 31
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = '10'
  end
  object _Fotom_Body: TButton
    Left = 57
    Top = 683
    Width = 73
    Height = 23
    Caption = '_Fotom_Body'
    TabOrder = 9
    Visible = False
    OnClick = _Fotom_BodyClick
  end
  object _Ploskost: TButton
    Left = 183
    Top = 683
    Width = 50
    Height = 23
    Caption = '_Ploskost'
    TabOrder = 10
    Visible = False
    OnClick = _PloskostClick
  end
  object Memo1: TMemo
    Left = 239
    Top = 684
    Width = 50
    Height = 22
    Lines.Strings = (
      'Memo1')
    TabOrder = 11
    Visible = False
  end
  object btHideFB: TButton
    Left = 54
    Top = 482
    Width = 75
    Height = 25
    Caption = #1057#1082#1088#1099#1090#1100' '#1060#1058
    TabOrder = 12
    OnClick = btHideFBClick
  end
  object btDeleteAll: TButton
    Left = 8
    Top = 426
    Width = 296
    Height = 45
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1105
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = btDeleteAllClick
  end
  object btCancel: TButton
    Left = 199
    Top = 188
    Width = 97
    Height = 49
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = btCancelClick
  end
  object Edit4: TEdit
    Left = 221
    Top = 342
    Width = 41
    Height = 32
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    Text = '100'
  end
  object rbDeg0_180: TRadioButton
    Left = 195
    Top = 276
    Width = 86
    Height = 18
    Caption = '0-180 Deg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 16
    OnClick = rbDeg0_180Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 548
    Width = 919
    Height = 19
    Panels = <
      item
        Text = 'Calc'
        Width = 300
      end
      item
        Text = 'Progress'
        Width = 50
      end>
    ExplicitTop = 547
    ExplicitWidth = 915
  end
  object Button4: TButton
    Left = 168
    Top = 482
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 18
    OnClick = Button4Click
  end
  object btReconnect: TButton
    Left = 8
    Top = 41
    Width = 296
    Height = 32
    Caption = #1055#1077#1088#1077#1087#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1082' '#1082#1086#1084#1087#1072#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 19
    OnClick = btReconnectClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 35
    TabOrder = 20
    object Button6: TButton
      Left = 0
      Top = 0
      Width = 35
      Height = 35
      Hint = #1058#1088#1080#1072#1085#1075#1091#1083#1103#1094#1080#1103' '#1086#1090#1088#1072#1078#1072#1090#1077#1083#1103
      Caption = #1058#1088' '#1054#1090#1088
      TabOrder = 0
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 34
      Top = 0
      Width = 35
      Height = 35
      Caption = #1058#1088#1048#1089#1090
      TabOrder = 1
      OnClick = Button7Click
    end
  end
  object rbDeg90_270: TRadioButton
    Left = 201
    Top = 300
    Width = 113
    Height = 17
    Caption = 'rbDeg90_270'
    TabOrder = 21
    OnClick = rbDeg90_270Click
  end
  object TreeView1: TTreeView
    Left = 320
    Top = 300
    Width = 121
    Height = 53
    Indent = 19
    TabOrder = 22
  end
  object cbInvert: TCheckBox
    Left = 24
    Top = 320
    Width = 249
    Height = 17
    Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1080#1079#1083#1091#1095#1077#1085#1080#1103
    TabOrder = 23
  end
  object MainMenu1: TMainMenu
    Left = 840
    Top = 48
    object N11: TMenuItem
      Caption = #1060#1072#1081#1083
      object N1: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' '#1050#1086#1084#1087#1072#1089' ...'
        OnClick = N1Click
      end
    end
    object N2: TMenuItem
      Caption = #1042#1080#1076
      object N4: TMenuItem
        Caption = #1055#1086#1083#1091#1087#1088#1086#1079#1088#1072#1095#1085#1072#1103' '#1079#1072#1083#1080#1074#1082#1072' ('#1082#1086#1085#1090#1091#1088')'
        OnClick = N4Click
      end
      object N8: TMenuItem
        Caption = #1055#1086#1083#1091#1087#1088#1086#1079#1088#1072#1095#1085#1072#1103' '#1079#1072#1083#1080#1074#1082#1072' ('#1090#1088#1077#1091#1075#1086#1083#1100#1085#1080#1082#1072#1080')'
        OnClick = N8Click
      end
      object N3: TMenuItem
        Caption = #1058#1088#1080#1072#1085#1075#1091#1083#1103#1094#1080#1103' ('#1090#1088#1077#1091#1075#1086#1083#1100#1085#1080#1082#1080')'
        OnClick = N3Click
      end
    end
    object N5: TMenuItem
      Caption = #1058#1088#1080#1072#1085#1075#1091#1083#1103#1094#1080#1103
      object N6: TMenuItem
        Caption = #1058#1088#1080#1072#1085#1075#1091#1083#1103#1094#1080#1103' '#1086#1090#1088#1072#1078#1072#1090#1077#1083#1103
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = #1058#1088#1080#1072#1085#1075#1091#1083#1103#1094#1080#1103' '#1080#1089#1090#1086#1095#1085#1080#1082#1072'/'#1086#1074
        OnClick = N7Click
      end
      object N9: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1084#1086#1076#1077#1083#1100
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1089#1086#1093#1088'.'
        OnClick = N10Click
      end
    end
    object N22: TMenuItem
      Caption = #1058#1088#1072#1089#1089#1080#1088#1086#1074#1082#1072
      object N24: TMenuItem
        Caption = #1058#1088#1072#1089#1089#1080#1088#1086#1074#1082#1072
      end
      object N23: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1090#1088#1072#1089#1089#1080#1088#1086#1074#1082#1080
        OnClick = N23Click
      end
    end
    object N16: TMenuItem
      Caption = #1054#1090#1088#1080#1089#1086#1074#1082#1072' '#1083#1091#1095#1077#1081
      object N17: TMenuItem
        Caption = #1054#1090#1086#1073#1088#1072#1079#1080#1090#1100
        OnClick = N17Click
      end
      object N20: TMenuItem
        Caption = #1057#1082#1088#1099#1090#1100
        OnClick = N20Click
      end
      object N18: TMenuItem
        Caption = #1055#1088#1103#1084#1099#1077
        OnClick = N18Click
      end
      object N19: TMenuItem
        Caption = '1'#1077' '#1054#1090#1088#1072#1078#1077#1085#1080#1077
        OnClick = N19Click
      end
      object N21: TMenuItem
        Caption = '2'#1077' '#1054#1090#1088#1072#1078#1077#1085#1080#1077
        OnClick = N21Click
      end
      object N31: TMenuItem
        Caption = '3'#1077' '#1054#1090#1088#1072#1078#1077#1085#1080#1077
        OnClick = N31Click
      end
    end
    object N12: TMenuItem
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
      object N13: TMenuItem
        Caption = #1050#1057#1057
        OnClick = N13Click
      end
      object N14: TMenuItem
        Caption = #1060#1086#1090#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1086#1077' '#1090#1077#1083#1086
        OnClick = N14Click
      end
      object N15: TMenuItem
        Caption = #1054#1089#1074#1077#1097#1105#1085#1085#1086#1089#1090#1100
        OnClick = N15Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 848
    Top = 104
  end
end
