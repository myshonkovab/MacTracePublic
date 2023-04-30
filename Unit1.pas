﻿unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, ksTLB,
  ksConstTLB,
  math, ComObj, Vcl.ComCtrls, Vcl.Samples.Gauges, SyncObjs, Vcl.ExtCtrls, Unit2;
      // asda sdasdasdqweqew
type
  Array_Trass = array [1 .. 15] of double;

  TForm1 = class(TForm)
    Frame21: TFrame2;
    btTrassirovka: TButton;
    MainMenu1: TMainMenu;
    N11: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem; // Триангуляция отражателя
    N7: TMenuItem;
    _Luch: TButton;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem; //
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Gauge1: TGauge;
    Label3: TLabel;
    CheckBox2: TCheckBox;
    _KSS: TButton;
    Edit3: TEdit;
    _Fotom_Body: TButton;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    _Ploskost: TButton;
    Memo1: TMemo;
    btHideFB: TButton;
    Label4: TLabel;
    btDeleteAll: TButton;
    btCancel: TButton;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N20: TMenuItem;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    StatusBar1: TStatusBar;
    Button4: TButton;
    btReconnect: TButton;
    Panel1: TPanel;
    Button6: TButton;
    Button7: TButton;
    rbDeg0_180: TRadioButton;
    rbDeg90_270: TRadioButton;
    TreeView1: TTreeView;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    cbInvert: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    Procedure Fibanachi_V(n, n_2: integer; Fi: double);
    Procedure Fibanachi_V_m(n, n_2: integer; Fi: double);
    function Trass(x0, y0, z0, x01, y01, z01, Svet_Pottok: double): Array_Trass;
    function Otr(x1, y1, z1, x2, y2, z2, A, B, C: double): Array_Trass;
    function S_Plo(x1, y1, z1, x2, y2, z2, x3, y3, z3: double): double;
    function D_ras(x1, y1, z1, n_x, n_y, n_z, d, x0, y0, z0, l, m, n: double)
      : Array_Trass;
    function Live_Lu(Rez: Array_Trass; n: double): Boolean;
    procedure _LuchClick(Sender: TObject);
    procedure btTrassirovkaClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure _KSSClick(Sender: TObject);
    procedure _Fotom_BodyClick(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure _PloskostClick(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure btHideFBClick(Sender: TObject);
    procedure btDeleteAllClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure rbDeg0_180Click(Sender: TObject);
    procedure rbDeg90_270Click(Sender: TObject);
    procedure btReconnectClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure Frame21Click(Sender: TObject);

  private
    n_cell_col: integer;
    Flag_Kss_1: integer;
    Flag_Fotom_B: integer;
    Deg_1_KSS, Deg_2_KSS: integer;
    { Private declarations }
  public

    Flag_Fotom_Body: Boolean;
    Mnoj_Fotom: double;
    { Public declarations }
  end;

  // Здесь необходимо описать класс TMyThread:    это описание потока
  TMyThread = class(TThread)
  private
    { Private declarations }
    x0, y0, z0, x01, y01, z01, Svet_Pottok: double;
    Flag_Rez: Boolean;
    Rez1, Rez_Otr1, Rez2: Array_Trass;
    n: integer;
    procedure Live_Lu();
  protected
    procedure Execute; override;
  end;

const
  // константа документа
  pTop_Part = -1;

var
  Form1: TForm1;
  // интерфей системы КОМПАС
  kompas: KompasObject;
  // Интерфейс документа модели КОМПАС
  Document3D: ksDocument3D;
  // Интерфейс компонента
  Part: ksPart;
  // Интерфейс массива компонента
  PartCollection: ksPartCollection;

  TraceWorking: Boolean;
  connected: Boolean; // подключено к компас

  CS: TCriticalSection;

  Cur: integer;

  Max: double;

  Kol_Ist: integer;

  Triang_Otr, Triang_Ist, Triang_ALL, Triang_Plosk: TextFile; // текстовые файлы
  PointsArray: Array of Array of single;
  // Многомерный массив треугольников отражателя
  PointsArray2: Array of Array of single;
  // Многомерный массив треугольников источника
  Points_ALL: Array of Array of single;
  // Многомерный массив совместный всего и вся кроме лучей
  Light_Array: Array of Array of single; // Многомерный массив лучей
  Plosk_Array: Array of Array of single;
  // Многомерный массив расчетной плоскоски
  Array_Trass_End: Array of Array of single;
  // Многомерный массив координат лучей_финальная тррасировка окончание
  Array_Fotom: Array of Array of single;
  Array_Fotom_Body: Array of Array of single;
  Array_Fotom_End: Array of Array of single;
  Array_Fotom_Exp: Array of Array of single;
  Array_Fotom_End_2: Array of Array of single; // удалить потом
  Array_Fotom_End_3: Array of Array of single; // удалить потом
  Array_Fotom_End_20: Array of Array of single; // удалить потом
  Array_KSS: Array of Array of single;
  Array_Osvet: Array of Array of single;
  Strk, Strk2, Strk_ALL, Strk_L, Strk_P, Strk_End, Strk_Fotom, Strk_Fotom_Body,
    Strk_Fotom_End, RaTaTa, RaTaTa_3, RaTaTa_20, Strk_Fotom_Exp,
    Strk_Osvet: integer;
  // Колво строк в масиве
  Strk_Kss: integer;

implementation

uses Trian_Otr, Trian_Ist, KSS_Form, UnitTraceSettings;

{$R *.dfm}

// -------ФУНКЦИИ-------------
// Живые лучи?:
function TForm1.Live_Lu(Rez: Array_Trass; n: double): Boolean;
var
  x_A, y_A, z_A, Fi: double;
begin
  if (Floor(Rez[7]) = 3) or (Floor(Rez[7]) = -1) then
  begin
    x_A := Rez[4] - Rez[1];
    y_A := Rez[5] - Rez[2];
    z_A := Rez[6] - Rez[3];
    Fi := (RadToDeg(ArcTan2(y_A, x_A)));

    Array_Trass_End[Strk_End - 1, 1] := Rez[1];
    Array_Trass_End[Strk_End - 1, 2] := Rez[2];
    Array_Trass_End[Strk_End - 1, 3] := Rez[3];
    Array_Trass_End[Strk_End - 1, 4] := Rez[4];
    Array_Trass_End[Strk_End - 1, 5] := Rez[5];
    Array_Trass_End[Strk_End - 1, 6] := Rez[6];
    Array_Trass_End[Strk_End - 1, 7] := n; // жизнь (отражение)
    Array_Trass_End[Strk_End - 1, 8] := Rez[12]; // световой поток
    Array_Trass_End[Strk_End - 1, 9] := 0;
    // 0 - конец, 1- продолжается отражение, 3 - умер на источнике излучения.
    Array_Trass_End[Strk_End - 1, 10] := Rez[11];

    Array_Trass_End[Strk_End - 1, 11] :=
      (RadToDeg(ArcCos(z_A / (sqrt(sqr(x_A) + sqr(y_A) + sqr(z_A))))));
    if Fi < 0 then
    begin
      Array_Trass_End[Strk_End - 1, 12] := 360 + Fi;
    end
    else
    begin
      Array_Trass_End[Strk_End - 1, 12] := Fi;
    end;

    inc(Strk_End);
    // SetLength(Array_Trass_End, Strk_End, 15);
    result := False;
  end;

  if (Floor(Rez[7]) = 1) then
  begin
    Array_Trass_End[Strk_End - 1, 1] := Rez[1];
    Array_Trass_End[Strk_End - 1, 2] := Rez[2];
    Array_Trass_End[Strk_End - 1, 3] := Rez[3];
    Array_Trass_End[Strk_End - 1, 4] := Rez[4];
    Array_Trass_End[Strk_End - 1, 5] := Rez[5];
    Array_Trass_End[Strk_End - 1, 6] := Rez[6];
    Array_Trass_End[Strk_End - 1, 7] := n; // жизнь (отражение)
    Array_Trass_End[Strk_End - 1, 8] := Rez[12] * Rez[8]; // световой поток
    // Array_Trass_End[Strk_End-1 ,8]:=Rez[12];   // световой поток
    Array_Trass_End[Strk_End - 1, 9] := 1;
    // 0 - конец, 1- продолжается отражение, 3 - умер на источнике излучения.
    Array_Trass_End[Strk_End - 1, 10] := Rez[11];
    inc(Strk_End);
    // SetLength(Array_Trass_End, Strk_End, 15);
    result := True;
  end;

  if (Floor(Rez[7]) = 2) then
  begin
    Array_Trass_End[Strk_End - 1, 1] := Rez[1];
    Array_Trass_End[Strk_End - 1, 2] := Rez[2];
    Array_Trass_End[Strk_End - 1, 3] := Rez[3];
    Array_Trass_End[Strk_End - 1, 4] := Rez[4];
    Array_Trass_End[Strk_End - 1, 5] := Rez[5];
    Array_Trass_End[Strk_End - 1, 6] := Rez[6];
    Array_Trass_End[Strk_End - 1, 7] := n; // жизнь (отражение)
    Array_Trass_End[Strk_End - 1, 8] := 0; // световой поток
    Array_Trass_End[Strk_End - 1, 9] := 2;
    // 0 - конец, 1- продолжается отражение, 2 - умер на источнике излучения.
    inc(Strk_End);
    // SetLength(Array_Trass_End, Strk_End, 15);
    result := False;
  end;

end;

// Площадь треугольника:    Формула Герона – формула для вычисления площади треугольника S по длинам его сторон a, b, c
function TForm1.S_Plo(x1, y1, z1, x2, y2, z2, x3, y3, z3: double): double;
var
  A, B, C, p, S: double;
begin

  A := sqrt((Power((x2 - x1), 2) + Power((y2 - y1), 2) + Power((z2 - z1), 2)));
  B := sqrt((Power((x3 - x2), 2) + Power((y3 - y2), 2) + Power((z3 - z2), 2)));
  C := sqrt((Power((x3 - x1), 2) + Power((y3 - y1), 2) + Power((z3 - z1), 2)));
  p := (A + B + C) / 2;
  S := sqrt(p * (p - A) * (p - B) * (p - C));
  result := S;
end;

//
function TForm1.D_ras(x1, y1, z1, n_x, n_y, n_z, d, x0, y0, z0, l, m, n: double)
  : Array_Trass;
var
  p_n, u_n, D_ra: double;
begin
  p_n := (x0 * n_x) + (y0 * n_y) + (z0 * n_z);
  u_n := (l * n_x) + (m * n_y) + (n * n_z);
  D_ra := ((d - p_n) / (u_n));

  result[1] := D_ra;
  result[2] := n_x;
  result[3] := n_y;
  result[4] := n_z;
end;

// Расчет вектора отражения
function TForm1.Otr(x1, y1, z1, x2, y2, z2, A, B, C: double): Array_Trass;
var
  L_2, M_2, n_2, l, m, n, sklr, norm, An, Bn, Cn: double;
begin
  l := x2 - x1;
  m := y2 - y1;
  n := z2 - z1;
  norm := sqrt(sqr(abs(A)) + sqr(abs(B)) + sqr(abs(C)));
  An := A / norm;
  Bn := B / norm;
  Cn := C / norm;

  sklr := (l * An) + (m * Bn) + (n * Cn);
  L_2 := l - (2 * sklr * An);
  M_2 := m - (2 * sklr * Bn);
  n_2 := n - (2 * sklr * Cn);
  result[1] := x2;
  result[2] := y2;
  result[3] := z2;
  result[4] := x2 + L_2 * 25;
  result[5] := y2 + M_2 * 25;
  result[6] := z2 + n_2 * 25;
end;

//
procedure TForm1.rbDeg0_180Click(Sender: TObject);
begin
  Flag_Kss_1 := 0;
end;

//
procedure TForm1.rbDeg90_270Click(Sender: TObject);
begin
  Flag_Kss_1 := 0;
end;

// Трассировка    (начало и конец вектора излучения (до пересечения с плоскостью) + поток в луче?)
function TForm1.Trass(x0, y0, z0, x01, y01, z01, Svet_Pottok: double)
  : Array_Trass;
var
  l, m, n: double;
  i, i1, k, k1, j, j1: integer;
  n_x, n_y, n_z, d: double;
  D_ras_Arayy: Array_Trass;
  S1, S2, S3, S0, S_raz: double;
  Xt, Yt, Zt, x1, y1, z1, x2, y2, z2, x3, y3, z3: double;
  Flag_end_Tr: Boolean;
begin
  l := x01 - x0;
  m := y01 - y0;
  n := z01 - z0;
  Flag_end_Tr := True;

  if Flag_end_Tr then
  begin
    i1 := 0;
    for i := 0 to ((Strk_ALL - 4) div 3) do
    // while (Points_ALL[i1, 4] > 0) do
    begin

      if (Points_ALL[i1, 4] = 2) then //
      begin
        x1 := Points_ALL[i1, 1];
        y1 := Points_ALL[i1, 2];
        z1 := Points_ALL[i1, 3];
        x2 := Points_ALL[i1 + 1, 1];
        y2 := Points_ALL[i1 + 1, 2];
        z2 := Points_ALL[i1 + 1, 3];
        x3 := Points_ALL[i1 + 2, 1];
        y3 := Points_ALL[i1 + 2, 2];
        z3 := Points_ALL[i1 + 2, 3];
        n_x := Points_ALL[i1, 8];
        n_y := Points_ALL[i1, 9];
        n_z := Points_ALL[i1, 10];
        d := Points_ALL[i1, 11];
        D_ras_Arayy := D_ras(x1, y1, z1, n_x, n_y, n_z, d, x0, y0, z0, l, m, n);
        if D_ras_Arayy[1] > 0.0001 then
        begin
          Xt := x0 + l * D_ras_Arayy[1];
          Yt := y0 + m * D_ras_Arayy[1];
          Zt := z0 + n * D_ras_Arayy[1];
          S1 := S_Plo(x1, y1, z1, x2, y2, z2, Xt, Yt, Zt);
          S2 := S_Plo(x2, y2, z2, x3, y3, z3, Xt, Yt, Zt);
          S3 := S_Plo(x3, y3, z3, x1, y1, z1, Xt, Yt, Zt);
          S0 := S_Plo(x1, y1, z1, x2, y2, z2, x3, y3, z3);
          S_raz := (abs((S1 + S2 + S3 - S0)));
          if ((S_raz) < 0.0001) then
          begin
            result[1] := x0;
            result[2] := y0;
            result[3] := z0;
            result[4] := Xt;
            result[5] := Yt;
            result[6] := Zt;
            result[7] := Points_ALL[i1, 4];
            result[8] := Points_ALL[i1, 5];
            result[9] := Points_ALL[i1, 6];
            result[10] := Points_ALL[i1, 7];
            result[11] := Points_ALL[i1, 12];
            // номер треугольника если плоскость
            result[12] := Svet_Pottok;
            result[13] := Points_ALL[i1, 8]; // нормаль для треугольника
            result[14] := Points_ALL[i1, 9];
            result[15] := Points_ALL[i1, 10];
            Flag_end_Tr := False;
            break;
          end;
        end;
      end;
      i1 := i1 + 3;
    end;
  end;

  if Flag_end_Tr then
  begin
    k1 := 0;
    for k := 0 to ((Strk_ALL - 4) div 3) do
    begin
      if (Points_ALL[k1, 4] = 1) and ((Points_ALL[k1, 5]) > 0.01) then //
      begin
        x1 := Points_ALL[k1, 1];
        y1 := Points_ALL[k1, 2];
        z1 := Points_ALL[k1, 3];
        x2 := Points_ALL[k1 + 1, 1];
        y2 := Points_ALL[k1 + 1, 2];
        z2 := Points_ALL[k1 + 1, 3];
        x3 := Points_ALL[k1 + 2, 1];
        y3 := Points_ALL[k1 + 2, 2];
        z3 := Points_ALL[k1 + 2, 3];
        n_x := Points_ALL[k1, 8];
        n_y := Points_ALL[k1, 9];
        n_z := Points_ALL[k1, 10];
        d := Points_ALL[k1, 11];
        D_ras_Arayy := D_ras(x1, y1, z1, n_x, n_y, n_z, d, x0, y0, z0, l, m, n);
        if D_ras_Arayy[1] > 0.0001 then
        begin
          Xt := x0 + l * D_ras_Arayy[1];
          Yt := y0 + m * D_ras_Arayy[1];
          Zt := z0 + n * D_ras_Arayy[1];
          S1 := S_Plo(x1, y1, z1, x2, y2, z2, Xt, Yt, Zt);
          S2 := S_Plo(x2, y2, z2, x3, y3, z3, Xt, Yt, Zt);
          S3 := S_Plo(x3, y3, z3, x1, y1, z1, Xt, Yt, Zt);
          S0 := S_Plo(x1, y1, z1, x2, y2, z2, x3, y3, z3);
          S_raz := (abs((S1 + S2 + S3 - S0)));
          if ((S_raz) < 0.00001) then
          begin
            result[1] := x0;
            result[2] := y0;
            result[3] := z0;
            result[4] := Xt;
            result[5] := Yt;
            result[6] := Zt;
            result[7] := Points_ALL[k1, 4];
            result[8] := Points_ALL[k1, 5];
            result[9] := Points_ALL[k1, 6];
            result[10] := Points_ALL[k1, 7];
            result[11] := Points_ALL[k1, 12];
            // номер треугольника если плоскость
            result[12] := Svet_Pottok;
            result[13] := Points_ALL[k1, 8]; // нормаль для треугольника
            result[14] := Points_ALL[k1, 9];
            result[15] := Points_ALL[k1, 10];
            Flag_end_Tr := False;
            break;
          end;
        end;
      end;
      k1 := k1 + 3;
    end;
  end;

  if CheckBox2.Checked then
  begin
    if Flag_end_Tr then
    begin
      k1 := 0;
      for k := 0 to ((Strk_ALL - 4) div 3) do
      begin
        if (Points_ALL[k1, 4] = 1) and ((Points_ALL[k1, 5]) = 0) then //
        begin
          x1 := Points_ALL[k1, 1];
          y1 := Points_ALL[k1, 2];
          z1 := Points_ALL[k1, 3];
          x2 := Points_ALL[k1 + 1, 1];
          y2 := Points_ALL[k1 + 1, 2];
          z2 := Points_ALL[k1 + 1, 3];
          x3 := Points_ALL[k1 + 2, 1];
          y3 := Points_ALL[k1 + 2, 2];
          z3 := Points_ALL[k1 + 2, 3];
          n_x := Points_ALL[k1, 8];
          n_y := Points_ALL[k1, 9];
          n_z := Points_ALL[k1, 10];
          d := Points_ALL[k1, 11];
          D_ras_Arayy := D_ras(x1, y1, z1, n_x, n_y, n_z, d, x0, y0,
            z0, l, m, n);
          if D_ras_Arayy[1] > 0.0001 then
          begin
            Xt := x0 + l * D_ras_Arayy[1];
            Yt := y0 + m * D_ras_Arayy[1];
            Zt := z0 + n * D_ras_Arayy[1];
            S1 := S_Plo(x1, y1, z1, x2, y2, z2, Xt, Yt, Zt); // Площ треуг
            S2 := S_Plo(x2, y2, z2, x3, y3, z3, Xt, Yt, Zt); // Площ треуг
            S3 := S_Plo(x3, y3, z3, x1, y1, z1, Xt, Yt, Zt); // Площ треуг
            S0 := S_Plo(x1, y1, z1, x2, y2, z2, x3, y3, z3); // Площ треуг
            S_raz := (abs((S1 + S2 + S3 - S0)));
            if ((S_raz) < 0.0001) then
            begin
              result[1] := x0;
              result[2] := y0;
              result[3] := z0;
              result[4] := Xt;
              result[5] := Yt;
              result[6] := Zt;
              result[7] := Points_ALL[k1, 4];
              result[8] := Points_ALL[k1, 5];
              result[9] := Points_ALL[k1, 6];
              result[10] := Points_ALL[k1, 7];
              result[11] := Points_ALL[k1, 12];
              // номер треугольника если плоскость
              result[12] := Svet_Pottok;
              result[13] := Points_ALL[k1, 8]; // нормаль для треугольника
              result[14] := Points_ALL[k1, 9];
              result[15] := Points_ALL[k1, 10];
              Flag_end_Tr := False;
              break;
            end;
          end;
        end;
        k1 := k1 + 3;
      end;
    end;
  end;

  if Flag_end_Tr then
  begin
    Xt := x0 + l * 75;
    Yt := y0 + m * 75;
    Zt := z0 + n * 75;
    result[1] := x0;
    result[2] := y0;
    result[3] := z0;
    result[4] := Xt;
    result[5] := Yt;
    result[6] := Zt;
    result[7] := -1;
    result[8] := 0;
    result[9] := 1;
    result[10] := 0;
    result[11] := 0;
    result[12] := Svet_Pottok;
    result[13] := 0; // нормаль для треугольника
    result[14] := 0;
    result[15] := 0;
    Flag_end_Tr := False;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.rbDeg0_180.Checked := True;
  Deg_1_KSS := 90;
  Deg_2_KSS := 270;
  connected := True;
  try
    kompas := KompasObject(GetActiveOleObject('Kompas.Application.5'));
    Document3D := ksDocument3D(kompas.Document3D());
    Part := ksPart(Document3D.GetPart(pTop_Part));
    try
      Document3D := ksDocument3D(kompas.ActiveDocument3D);
      Part := ksPart(Document3D.GetPart(pTop_Part));
    Except
      ShowMessage('Документ не является деталью или сборкой');
      Form1.StatusBar1.Panels[0].Text := 'Компас не подключен';
      connected := False;
    end;
  Except
    ShowMessage('Компас не запущен');
    Form1.StatusBar1.Panels[0].Text := 'Компас не запущен';
    connected := False;
  end;
  if connected then
    Form1.StatusBar1.Panels[0].Text := 'Компас подключен';
end;

procedure TForm1.Frame21Click(Sender: TObject);
begin

end;

// Загрузить последнее сохр.
procedure TForm1.N10Click(Sender: TObject);
var
  x1, y1, z1, type_t, specul, diff, transp, n_x, n_y, n_z, d, Nom_t, x12, y12,
    z12, type_t2, specul2, diff2, transp2, N_x2, N_y2, N_z2, d2, Nom_t2: double;
  B: Boolean;
  Start, Stop: cardinal;
  Elapsed: cardinal;
begin
  Frame21.Flag_Kont := True;
  Frame21.Flag_Body := True;

  PointsArray := nil;
  PointsArray2 := nil;
  Points_ALL := nil;

  Light_Array := nil;
  Plosk_Array := nil;
  Array_Trass_End := nil;
  Array_Fotom := nil;
  Array_Fotom_Body := nil;
  Array_Fotom_End := nil;
  Array_Fotom_Exp := nil;
  Array_Fotom_End_2 := nil;
  Array_Fotom_End_3 := nil;
  Array_Fotom_End_20 := nil;
  Array_KSS := nil;
  Array_Osvet := nil;



  // Start:=GetTickCount; //засекли начало выполнения операции

  AssignFile(Triang_Otr, 'DATA\Triang_Otr.txt');
  reset(Triang_Otr);
  AssignFile(Triang_Ist, 'DATA\Triang_Ist.txt');
  reset(Triang_Ist);
  AssignFile(Triang_ALL, 'DATA\Triang_ALL.txt');
  reset(Triang_ALL);

  while not eof(Triang_Ist) do
  begin
    Readln(Triang_Ist, x1, y1, z1, type_t, specul, diff, transp, n_x, n_y, n_z,
      d, Nom_t);
    If Pos('-10', floattostr(x1)) <> 0 Then
    begin
      Readln(Triang_Ist, x1, y1, z1, type_t, specul, diff, transp, n_x, n_y,
        n_z, d, Nom_t);
      Strk2 := trunc(x1);
      Kol_Ist := trunc(y1);
      break;
    end;
  end;

  while not eof(Triang_ALL) do
  begin
    Readln(Triang_ALL, x12, y12, z12, type_t2, specul2, diff2, transp2, N_x2,
      N_y2, N_z2, d2, Nom_t2);
    If Pos('-10', floattostr(x12)) <> 0 Then
    begin
      Readln(Triang_ALL, x12, y12, z12, type_t2, specul2, diff2, transp2, N_x2,
        N_y2, N_z2, d2, Nom_t2);
      Strk_ALL := trunc(x12);
      break;
    end;
  end;

  SetLength(PointsArray, Strk + 1, 15);
  SetLength(PointsArray2, Strk2 + 1, 15);
  SetLength(Points_ALL, Strk_ALL + 1, 15);

  Strk := 1;
  Strk2 := 1;
  Strk_ALL := 1;

  B := False;
  while not eof(Triang_Ist) do
  begin
    Readln(Triang_Ist, x1, y1, z1, type_t, specul, diff, transp, n_x, n_y, n_z,
      d, Nom_t);
    if B = False then
    begin
      If Pos('-20', floattostr(x1)) <> 0 Then
      begin
        B := True;
        continue;
      end;
    end;
    if B then
    begin

      PointsArray2[Strk2 - 1, 1] := (x1);
      PointsArray2[Strk2 - 1, 2] := (y1);
      PointsArray2[Strk2 - 1, 3] := (z1);
      PointsArray2[Strk2 - 1, 4] := (type_t);
      PointsArray2[Strk2 - 1, 5] := (specul);
      PointsArray2[Strk2 - 1, 6] := (diff);
      PointsArray2[Strk2 - 1, 7] := (transp);
      PointsArray2[Strk2 - 1, 8] := (n_x);
      PointsArray2[Strk2 - 1, 9] := (n_y);
      PointsArray2[Strk2 - 1, 10] := (n_z);
      PointsArray2[Strk2 - 1, 11] := d;
      PointsArray2[Strk2 - 1, 12] := Nom_t;
      inc(Strk2);
    end; // Приращение строк в массиве
  end;

  B := False;
  while not eof(Triang_ALL) do
  begin
    Readln(Triang_ALL, x12, y12, z12, type_t2, specul2, diff2, transp2, N_x2,
      N_y2, N_z2, d2, Nom_t2);
    if B = False then
    begin
      If Pos('-20', floattostr(x12)) <> 0 Then
      begin
        B := True;
        continue;
      end;
    end;
    if B then
    begin
      Points_ALL[Strk_ALL - 1, 1] := (x12);
      Points_ALL[Strk_ALL - 1, 2] := (y12);
      Points_ALL[Strk_ALL - 1, 3] := (z12);
      Points_ALL[Strk_ALL - 1, 4] := (type_t2);
      Points_ALL[Strk_ALL - 1, 5] := (specul2);
      Points_ALL[Strk_ALL - 1, 6] := (diff2);
      Points_ALL[Strk_ALL - 1, 7] := (transp2);
      Points_ALL[Strk_ALL - 1, 8] := (N_x2);
      Points_ALL[Strk_ALL - 1, 9] := (N_y2);
      Points_ALL[Strk_ALL - 1, 10] := (N_z2);
      Points_ALL[Strk_ALL - 1, 11] := d2;
      Points_ALL[Strk_ALL - 1, 12] := Nom_t2;
      inc(Strk_ALL);
    end;
  end;

  dec(Strk2);
  dec(Strk_ALL);

  CloseFile(Triang_Otr);
  CloseFile(Triang_Ist);
  CloseFile(Triang_ALL);

  Frame21.Render;

  // Stop:=GetTickCount; //засекли окончание выполнения операции
  // Elapsed:=Stop-Start;//время в миллисекундах
  // showmessage(floattostr(Elapsed)+ ' ms');
end;

// КСС  :
procedure TForm1.N13Click(Sender: TObject);
begin

  if rbDeg0_180.Checked then
  begin
    Deg_1_KSS := 90;
    Deg_2_KSS := 270;
  end;

  if rbDeg90_270.Checked then
  begin
    Deg_1_KSS := 360;
    Deg_2_KSS := 180;
  end;

  if Array_KSS <> nil then
  begin
    if Flag_Kss_1 = strtoint(Edit3.Text) then
    begin
      form5.ShowModal;
    end
    else
    begin
      Flag_Kss_1 := strtoint(Edit3.Text);
      _KSS.Click;

    end;
  end
  else
  begin
    Flag_Kss_1 := strtoint(Edit3.Text);
    _KSS.Click;
  end;

end;

// ФТ
procedure TForm1.N14Click(Sender: TObject);
var
  i: integer;
  Max: double;
begin
  if Array_Fotom_End <> nil then
  begin
    if Flag_Fotom_B = strtoint(Edit3.Text) then
    begin
      btHideFB.Visible := True;
      Frame21.Flag_Kont := False;
      Frame21.Flag_Lu_St := False;
      Frame21.Flag_Lu_End := False;
      Frame21.Flag_Body := False;
      Frame21.Flag_Plos := False;
      Frame21.Flag_Fotom := True;
      Frame21.Render;
    end
    else
    begin
      Flag_Fotom_B := strtoint(Edit3.Text);
      _Fotom_Body.Click;
      Flag_Fotom_Body := True;
      Max := 0;
      for i := 0 to RaTaTa - 1 do
      begin
        if Max < Array_Fotom_End_2[i, 3] then
        begin
          Max := Array_Fotom_End_2[i, 3];
        end;
      end;
      Mnoj_Fotom := 3 / Max;
      btHideFB.Visible := True;
      Frame21.Flag_Kont := False;
      Frame21.Flag_Lu_St := False;
      Frame21.Flag_Lu_End := False;
      Frame21.Flag_Body := False;
      Frame21.Flag_Plos := False;
      Frame21.Flag_Fotom := True;
      Frame21.Render;
    end;
  end
  else
  begin
    Flag_Fotom_B := strtoint(Edit3.Text);
    _Fotom_Body.Click;
    Flag_Fotom_Body := True;
    Max := 0;
    for i := 0 to RaTaTa - 1 do
    begin
      if Max < Array_Fotom_End_2[i, 3] then
      begin
        Max := Array_Fotom_End_2[i, 3];
      end;
    end;
    Mnoj_Fotom := 3 / Max;
    btHideFB.Visible := True;
    Frame21.Flag_Kont := False;
    Frame21.Flag_Lu_St := False;
    Frame21.Flag_Lu_End := False;
    Frame21.Flag_Body := False;
    Frame21.Flag_Plos := False;
    Frame21.Flag_Fotom := True;
    Frame21.Render;
  end;

end;

// Освещенность
procedure TForm1.N15Click(Sender: TObject);
var
  i, j, k, n: integer;
  v, Fi, x, x1, x2, y, y1, y2, Sil, Sil1, Sil2, Sil3, Sil4: double;
  F1, F2, H: double;
  Flag_x2, Flag_y2: Boolean;
  Ap: Variant;
  DataRange: OLEVariant;
  Chart: OLEVariant;

  diagr: Variant;

  D_a, D_b, Rez, rez_Sunn, Svet, Sila, Svet_Summ, ReSvet: double;
  A, B, nx: integer;
  i1, i12, I5: integer;
begin

  Array_Osvet := nil;

  // if Plosk_Array = nil then
  begin
    _Ploskost.Click;
    H := Plosk_Array[0, 3] / 1000;
  end;

  Flag_x2 := True;
  Flag_y2 := True;
  Memo1.Clear;

  A := strtoint(Edit3.Text);
  B := 15;

  D_a := 90;
  D_b := 0;

  Strk_Osvet := 1; // Приращение строк в массиве
  SetLength(Array_Osvet, 999999, 15);

  for j := 0 to (90 div A) do
  begin
    D_b := 0;
    for i := 0 to (360 div B) - 1 do
    begin
      Svet_Summ := 0;
      nx := 0;
      for I5 := 0 to (Strk_End) - 1 do
      begin
        if (abs(Array_Trass_End[I5, 11]) > D_a) and
          (abs(Array_Trass_End[I5, 11]) < D_a + A) and
          (abs(Array_Trass_End[I5, 12]) > D_b) and
          (abs(Array_Trass_End[I5, 12]) < D_b + B) then
        begin
          Svet_Summ := Svet_Summ + Array_Trass_End[nx, 8];
          inc(nx);
        end;
      end;

      Array_Osvet[Strk_Osvet - 1, 1] := D_a + (A / 2);
      Array_Osvet[Strk_Osvet - 1, 2] := D_b;
      Array_Osvet[Strk_Osvet - 1, 3] := Svet_Summ * 942;

      D_b := D_b + B;

      inc(Strk_Osvet); // Приращение строк в массиве
      // SetLength(Array_Fotom_End, Strk_Fotom_End, 15);
    end;

    Array_Osvet[Strk_Osvet - 1, 1] := D_a + (A / 2);
    Array_Osvet[Strk_Osvet - 1, 2] := 359.999;
    Array_Osvet[Strk_Osvet - 1, 3] := Svet_Summ * 942;
    inc(Strk_Osvet);

    D_a := D_a + A;
  end;

  dec(Strk_Osvet); // Приращение строк в массиве
  SetLength(Array_Osvet, Strk_Osvet, 15);

  n := 0;
  if Array_Osvet <> nil then
  begin
    Ap := CreateOleObject('Excel.Application');
    Ap.Workbooks.Add;
    for i := 0 to n_cell_col - 1 do
    begin
      for j := 0 to n_cell_col - 1 do
      begin
        Flag_x2 := True;
        Flag_y2 := True;

        v := Plosk_Array[n, 5];
        Fi := Plosk_Array[n, 6];
        for k := 0 to Strk_Osvet - 1 do
        begin
          if (Array_Osvet[k, 1] < v) and (Array_Osvet[k, 2] < Fi) then
          begin
            x1 := Array_Osvet[k, 1];
            y1 := Array_Osvet[k, 2];
          end;

          if (Array_Osvet[k, 1] > v) and (Flag_x2 = True) and
            (Array_Osvet[k, 2] > Fi) and (Flag_y2 = True) then
          begin
            x2 := Array_Osvet[k, 1];
            Flag_x2 := False;
            y2 := Array_Osvet[k, 2];
            Flag_y2 := False;
          end;

        end;

        for k := 0 to Strk_Osvet - 1 do
        begin
          if (Array_Osvet[k, 1] = x1) and ((Array_Osvet[k, 2] = y1)) then
          begin
            Sil1 := Array_Osvet[k, 3];
          end;

          if (Array_Osvet[k, 1] = x1) and ((Array_Osvet[k, 2] = y2)) then
          begin
            Sil2 := Array_Osvet[k, 3];
          end;

          if (Array_Osvet[k, 1] = x2) and ((Array_Osvet[k, 2] = y1)) then
          begin
            Sil3 := Array_Osvet[k, 3];
          end;

          if (Array_Osvet[k, 1] = x2) and ((Array_Osvet[k, 2] = y2)) then
          begin
            Sil4 := Array_Osvet[k, 3];
          end;

        end;

        F1 := Sil1 + (v - x1) * ((Sil3 - Sil1) / (x2 - x1));

        F2 := Sil2 + (v - x1) * ((Sil4 - Sil2) / (x2 - x1));

        Sil := F1 + (Fi - y1) * ((F2 - F1) / (y2 - y1));




        // sqr(cos(DegToRad(v/sqr(H))));

        Ap.Cells[i + 1, j + 1] := Sil *
          ((1 + cos(DegToRad(2 * v))) / 2) / sqr(H);

        { memo1.Lines.Add(floattostr(Sil)+' '+floattostr(Sil1)+' '+floattostr(Sil2)+' '+
          floattostr(Sil3)+' '+floattostr(Sil4)+' '+floattostr(X1)+' '+
          floattostr(v)+' '+floattostr(x2)+' '+floattostr(y1)+' '+
          floattostr(fi)+' '+floattostr(y2)); }
        n := n + 4;
      end;
    end;

    diagr := Ap.Charts.Add; // добавление диаграммы
    diagr.ChartType := -4103;

    Ap.Visible := True;
  end
  else
  begin
    // _Fotom_Body.Click();
    // N15.Click();
  end;

end;

// Отобразить
procedure TForm1.N17Click(Sender: TObject);
begin
  Frame21.Flag_Lu_End_0 := False;
  Frame21.Flag_Lu_End_1 := False;
  Frame21.Flag_Lu_End_2 := False;
  Frame21.Flag_Lu_End_3 := False;
  Frame21.Flag_Lu_End_All := True;
  Frame21.Render;
end;

// прямые
procedure TForm1.N18Click(Sender: TObject);
begin
  Frame21.Flag_Lu_End_0 := True;
  Frame21.Flag_Lu_End_1 := False;
  Frame21.Flag_Lu_End_2 := False;
  Frame21.Flag_Lu_End_3 := False;
  Frame21.Flag_Lu_End_All := False;
  Frame21.Render;
end;

// 1-е отражение
procedure TForm1.N19Click(Sender: TObject);
begin
  Frame21.Flag_Lu_End_0 := False;
  Frame21.Flag_Lu_End_1 := True;
  Frame21.Flag_Lu_End_2 := False;
  Frame21.Flag_Lu_End_3 := False;
  Frame21.Flag_Lu_End_All := False;
  Frame21.Render;
end;

// Открыть файл Компас ...
procedure TForm1.N1Click(Sender: TObject);
var
  FileName: string;
  False_1: integer;
begin
  try
    kompas := KompasObject(GetActiveOleObject('Kompas.Application.5'));
    Document3D := ksDocument3D(kompas.Document3D());
    Part := ksPart(Document3D.GetPart(pTop_Part));
    False_1 := 0;
  Except
    False_1 := 1;
  end;
  if False_1 = 1 then
  begin
    try
      kompas := KompasObject(CreateOleObject('Kompas.Application.5'));
      Document3D := ksDocument3D(kompas.Document3D());
      Part := ksPart(Document3D.GetPart(pTop_Part));
    Except
    end;
  end;
  Document3D := ksDocument3D(kompas.Document3D());
  kompas.Visible := True;
  if OpenDialog1.Execute then
  begin
    FileName := OpenDialog1.FileName;
  end;
  Document3D.Open(FileName, False);
  Part := ksPart(Document3D.GetPart(pTop_Part));
end;

// Скрыть
procedure TForm1.N20Click(Sender: TObject);
begin
  Frame21.Flag_Lu_End_0 := False;
  Frame21.Flag_Lu_End_1 := False;
  Frame21.Flag_Lu_End_2 := False;
  Frame21.Flag_Lu_End_3 := False;
  Frame21.Flag_Lu_End_All := False;
  Frame21.Render;
end;

// 2-е отражение
procedure TForm1.N21Click(Sender: TObject);
begin
  Frame21.Flag_Lu_End_0 := False;
  Frame21.Flag_Lu_End_1 := False;
  Frame21.Flag_Lu_End_2 := True;
  Frame21.Flag_Lu_End_3 := False;
  Frame21.Flag_Lu_End_All := False;
  Frame21.Render;
end;

procedure TForm1.N23Click(Sender: TObject);
begin
  fmTraceSettings.Show;
end;

// 3-е отражение
procedure TForm1.N31Click(Sender: TObject);
begin
  Frame21.Flag_Lu_End_0 := False;
  Frame21.Flag_Lu_End_1 := False;
  Frame21.Flag_Lu_End_2 := False;
  Frame21.Flag_Lu_End_3 := True;
  Frame21.Flag_Lu_End_All := False;
  Frame21.Render;
end;

// Отображение: треугольники
procedure TForm1.N3Click(Sender: TObject);
begin
  Flag_Render := 2;
  Frame21.CheckBox1.Checked := True;
  Frame21.Render;
end;

// Полупрозрачная заливка (контур)
procedure TForm1.N4Click(Sender: TObject);
begin
  Flag_Render := 1;
  Frame21.CheckBox1.Checked := False;
  Frame21.Render;
end;

// Триангуляция отражателя
procedure TForm1.N6Click(Sender: TObject);
begin
  if connected then
    form3.Show
  else
    ShowMessage('Компас не подключен');
end;

// Триангуляция источника/ов
procedure TForm1.N7Click(Sender: TObject);
begin
  if connected then
    form4.Show
  else
    ShowMessage('Компас не подключен');
end;

// Отображение: Полупрозрачная заливка (треугольникаи)
procedure TForm1.N8Click(Sender: TObject);
begin
  Flag_Render := 2;
  Frame21.CheckBox1.Checked := False;
  Frame21.Render;
end;

// Сохранить текущую модель
procedure TForm1.N9Click(Sender: TObject);
var
  i, j, k, n, index: integer;
begin

  if PointsArray = nil then
  begin
    ShowMessage
      ('Отсутствуют файлы для сохранения: Триангуляция отражателей. Файл не сохранен');
  end
  else
  begin
    AssignFile(Triang_Otr, 'DATA\Triang_Otr.txt');
    Rewrite(Triang_Otr);
    Writeln(Triang_Otr, -10, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    Writeln(Triang_Otr, Strk, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    Writeln(Triang_Otr, -20, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    for i := 0 to Strk - 1 do
    begin
      Writeln(Triang_Otr, PointsArray[i, 1], ' ', PointsArray[i, 2], ' ',
        PointsArray[i, 3], ' ', PointsArray[i, 4], ' ', PointsArray[i, 5], ' ',
        PointsArray[i, 6], ' ', PointsArray[i, 7], ' ', PointsArray[i, 8], ' ',
        PointsArray[i, 9], ' ', PointsArray[i, 10], ' ',
        PointsArray[i, 11], ' ', 0);
    end;
    CloseFile(Triang_Otr);
  end;

  if PointsArray2 = nil then
  begin
    ShowMessage
      ('Отсутствуют файлы для сохранения: Триангуляция источников. Файл не сохранен');
  end
  else
  begin
    AssignFile(Triang_Ist, 'DATA\Triang_Ist.txt');
    Rewrite(Triang_Ist);
    Writeln(Triang_Ist, -10, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    Writeln(Triang_Ist, Strk2, ' ', Kol_Ist, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    Writeln(Triang_Ist, -20, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    for j := 0 to Strk2 - 1 do
    begin
      Writeln(Triang_Ist, PointsArray2[j, 1], ' ', PointsArray2[j, 2], ' ',
        PointsArray2[j, 3], ' ', PointsArray2[j, 4], ' ', PointsArray2[j, 5],
        ' ', PointsArray2[j, 6], ' ', PointsArray2[j, 7], ' ',
        PointsArray2[j, 8], ' ', PointsArray2[j, 9], ' ', PointsArray2[j, 10],
        ' ', PointsArray2[j, 11], ' ', 0);
    end;
    CloseFile(Triang_Ist);
    ShowMessage('Файлы сохранены в папку с программой');
  end;

  if Points_ALL = nil then
  begin
    ShowMessage
      ('Отсутствуют файлы для сохранения: Общая триангуляция. Файл не сохранен');
  end
  else
  begin
    AssignFile(Triang_ALL, 'DATA\Triang_ALL.txt');
    Rewrite(Triang_ALL);
    Writeln(Triang_ALL, -10, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    Writeln(Triang_ALL, Strk_ALL, ' ', Kol_Ist, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    Writeln(Triang_ALL, -20, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0,
      ' ', 0, ' ', 0, ' ', 0, ' ', 0, ' ', 0);
    for k := 0 to Strk_ALL - 1 do
    begin
      Writeln(Triang_ALL, Points_ALL[k, 1], ' ', Points_ALL[k, 2], ' ',
        Points_ALL[k, 3], ' ', Points_ALL[k, 4], ' ', Points_ALL[k, 5], ' ',
        Points_ALL[k, 6], ' ', Points_ALL[k, 7], ' ', Points_ALL[k, 8], ' ',
        Points_ALL[k, 9], ' ', Points_ALL[k, 10], ' ', Points_ALL[k, 11], ' ',
        Points_ALL[k, 12]);
    end;
    CloseFile(Triang_ALL);
  end;

end;

procedure TForm1.btTrassirovkaClick(Sender: TObject);
var
  q: integer;
  x0, y0, z0, x01, y01, z01, Svet_Pottok: double;
  Rez1, Rez_Otr1, Rez2: Array_Trass;
  End_Flag: Boolean;
  Start, Stop: cardinal;
  Elapsed: cardinal;
begin
  Light_Array := nil;

  Array_Trass_End := nil;
  Array_Fotom := nil;
  Array_Fotom_Body := nil;
  Array_Fotom_End := nil;
  Array_Fotom_Exp := nil;
  Array_Fotom_End_2 := nil;
  Array_Fotom_End_3 := nil;
  Array_Fotom_End_20 := nil;
  Array_KSS := nil;

  // Start:=GetTickCount; //засекли начало выполнения операции
  // Stop:=GetTickCount; //засекли окончание выполнения операции
  // Elapsed:=Stop-Start;//время в миллисекундах
  // showmessage(floattostr(Elapsed)+ ' ms');

  _Luch.Click;
  // прогресс бар:
  Gauge1.MinValue := 0;
  Gauge1.MaxValue := Strk_L - 2;

  DoubleBuffered := True;

  Strk_End := 1;
  SetLength(Array_Trass_End, 999999, 15);

  TraceWorking := True;
  CS := TCriticalSection.Create; // для защиты от одновременного доступа
  Cur := 0;

  for q := 0 to 25 do
  begin
    Application.ProcessMessages;
    TMyThread.Create(False); // <<true означает ручной запуск потока
  end;
  // Label1.Caption:='Готово';
end;

procedure TForm1._PloskostClick(Sender: TObject);
var
  Gab, Gab_reb, z, Gab_reb_Shag_X, Gab_reb_Shag_Y: double;
  i, j, n: integer;
  e1x, e1y, e1z, e2x, e2y, e2z: double;
  e1x2, e1y2, e1z2, e2x2, e2y2, e2z2: double;
  x_A, y_A, z_A, Fi: double;
begin
  Plosk_Array := nil;

  n_cell_col := 0;

  Strk_P := 9;
  SetLength(Plosk_Array, Strk_P, 15);

  Gab := 15000 / 2;

  Gab_reb := 250;

  Gab_reb_Shag_X := 0;
  Gab_reb_Shag_Y := 0;

  z := -2200;
  n := 1;

  Strk_P := 4;
  SetLength(Plosk_Array, sqr(ceil((Gab / Gab_reb) * 4)) + 10, 15);

  for j := 0 to (Floor((Gab * 2) / Gab_reb)) - 1 do
  begin
    Gab_reb_Shag_X := 0;
    for i := 0 to (Floor((Gab * 2) / Gab_reb)) - 1 do
    begin
      Plosk_Array[Strk_P - 4, 1] := -Gab + Gab_reb_Shag_X;
      Plosk_Array[Strk_P - 4, 2] := Gab - Gab_reb_Shag_Y;
      Plosk_Array[Strk_P - 4, 3] := z;

      Plosk_Array[Strk_P - 3, 1] := -Gab + Gab_reb_Shag_X + Gab_reb;
      Plosk_Array[Strk_P - 3, 2] := Gab - Gab_reb_Shag_Y;
      Plosk_Array[Strk_P - 3, 3] := z;

      Plosk_Array[Strk_P - 2, 1] := -Gab + Gab_reb_Shag_X + Gab_reb;
      Plosk_Array[Strk_P - 2, 2] := Gab - Gab_reb_Shag_Y - Gab_reb;
      Plosk_Array[Strk_P - 2, 3] := z;

      Plosk_Array[Strk_P - 1, 1] := -Gab + Gab_reb_Shag_X;
      Plosk_Array[Strk_P - 1, 2] := Gab - Gab_reb_Shag_Y - Gab_reb;
      Plosk_Array[Strk_P - 1, 3] := z;

      x_A := Plosk_Array[Strk_P - 4, 1] + (Gab_reb / 2);
      y_A := Plosk_Array[Strk_P - 4, 2] - (Gab_reb / 2);
      z_A := Plosk_Array[Strk_P - 4, 3];

      Fi := (RadToDeg(ArcTan2(y_A, x_A)));

      Plosk_Array[Strk_P - 4, 5] :=
        (RadToDeg(ArcCos(z_A / (sqrt(sqr(x_A) + sqr(y_A) + sqr(z_A))))));

      if Fi < 0 then
      begin
        Plosk_Array[Strk_P - 4, 6] := 360 + Fi;
      end
      else
      begin
        Plosk_Array[Strk_P - 4, 6] := Fi;
      end;


      // memo1.Lines.Add(floattostr(Plosk_Array[Strk_P - 4, 5])+' '+floattostr(Plosk_Array[Strk_P - 4, 6])) ;

      Plosk_Array[Strk_P - 4, 7] := 0;

      Plosk_Array[Strk_P - 4, 4] := 3;

      Plosk_Array[Strk_P - 4, 12] := n;


      // ------------------------------НОРМАЛЬ--------------------------------

      e1x := Plosk_Array[Strk_P - 3, 1] - Plosk_Array[Strk_P - 4, 1];
      e1y := Plosk_Array[Strk_P - 3, 2] - Plosk_Array[Strk_P - 4, 2];
      e1z := Plosk_Array[Strk_P - 3, 3] - Plosk_Array[Strk_P - 4, 3];

      e2x := Plosk_Array[Strk_P - 2, 1] - Plosk_Array[Strk_P - 4, 1];
      e2y := Plosk_Array[Strk_P - 2, 2] - Plosk_Array[Strk_P - 4, 2];
      e2z := Plosk_Array[Strk_P - 2, 3] - Plosk_Array[Strk_P - 4, 3];

      Plosk_Array[Strk_P - 4, 8] := (e1y * e2z) - (e1z * e2y);

      Plosk_Array[Strk_P - 4, 9] := (e1z * e2x) - (e1x * e2z);

      Plosk_Array[Strk_P - 4, 10] := (e1x * e2y) - (e1y * e2x);

      Plosk_Array[Strk_P - 4, 11] :=
        (Plosk_Array[Strk_P - 4, 8] * Plosk_Array[Strk_P - 4, 1]) +
        (Plosk_Array[Strk_P - 4, 9] * Plosk_Array[Strk_P - 4, 2]) +
        (Plosk_Array[Strk_P - 4, 10] * Plosk_Array[Strk_P - 4, 3]);
      // ------------------------------НОРМАЛЬ--------------------------------

      Strk_P := Strk_P + 4;

      inc(n);

      Gab_reb_Shag_X := Gab_reb_Shag_X + Gab_reb;
    end;

    Gab_reb_Shag_Y := Gab_reb_Shag_Y + Gab_reb;
    inc(n_cell_col);
  end;

  dec(Strk_P);
  SetLength(Plosk_Array, Strk_P, 15);

  // showmessage(inttostr(n_cell_col));
end;

procedure TForm1._LuchClick(Sender: TObject);
var
  Fi, d_Fi, prov: double;
  i, n_2, n: integer;
begin
  // Fi:=0;
  // n_2 := 3;             //50

  // определяем шаг градусов для вычисления?  n*n_2 - колво лучей источника
  if strtoint(Edit1.Text) < 15000 then // Количество лучей
  begin
    n_2 := 40;
    n := ceil(15000 / 40);
  end
  else
  begin
    n_2 := 45;
    n := ceil(strtoint(Edit1.Text) / n_2);
    if strtoint(Edit1.Text) > 299000 then
    begin
      n_2 := 60;
      n := ceil(strtoint(Edit1.Text) / n_2);
      if strtoint(Edit1.Text) > 499000 then
      begin
        n_2 := 90;
        n := ceil(strtoint(Edit1.Text) / n_2);
      end;
    end;

  end;

  d_Fi := 180 / n_2;
  Fi := 0;
  Randomize;
  Gauge1.MinValue := 0;
  Gauge1.MaxValue := n_2;

  Strk_L := 1;
  SetLength(Light_Array, (n * n_2) + 100, 10); // 5500
  for i := 0 to (n_2 - 1) do
  begin
    Application.ProcessMessages;
    // showMessage(inttostr(fmTraceSettings.radiogroup1.itemindex));
    case fmTraceSettings.radiogroup1.itemindex of
      - 1:
        ;
      0:
        Fibanachi_V(n, n_2, Fi);
      1:
        begin
          Fibanachi_V_m(n, n_2, Fi);
        end;
    end;

    Fi := Fi + d_Fi;
    Gauge1.Progress := i + 1;
  end;

  dec(Strk_L);
  SetLength(Light_Array, Strk_L, 10);

end;

procedure TForm1._KSSClick(Sender: TObject);
Var
  i, Bezumie: integer;
begin
  _Fotom_Body.Click;
  Max := 0;
  Bezumie := RaTaTa_3 - 1;

  Strk_Kss := 1; // Приращение строк в массиве
  SetLength(Array_KSS, 250000, 8);

  Array_KSS[Strk_Kss - 1, 1] := 0;
  Array_KSS[Strk_Kss - 1, 2] := 0;
  Array_KSS[Strk_Kss - 1, 3] := 0;

  for i := 0 to RaTaTa - 1 do
  begin
    Array_KSS[Strk_Kss, 1] := Array_Fotom_End_2[i, 1] - 90;
    Array_KSS[Strk_Kss, 2] := Array_Fotom_End_2[i, 2];
    Array_KSS[Strk_Kss, 3] := Array_Fotom_End_2[i, 3];
    if Max < Array_Fotom_End_2[i, 3] then
    begin
      Max := Array_Fotom_End_2[i, 3];
    end;
    inc(Strk_Kss); // Приращение строк в массиве
    // SetLength(Array_KSS, Strk_Kss, 8);
  end;

  for i := 0 to RaTaTa_3 - 1 do
  begin
    Array_KSS[Strk_Kss, 1] := 270 - Array_Fotom_End_3[Bezumie, 1];
    Array_KSS[Strk_Kss, 2] := Array_Fotom_End_3[Bezumie, 2];
    Array_KSS[Strk_Kss, 3] := Array_Fotom_End_3[Bezumie, 3];
    if Max < Array_Fotom_End_3[Bezumie, 3] then
    begin
      Max := Array_Fotom_End_3[Bezumie, 3];
    end;
    dec(Bezumie);
    inc(Strk_Kss); // Приращение строк в массиве
    // SetLength(Array_KSS, Strk_Kss, 8);
  end;

  Array_KSS[Strk_Kss, 1] := 180;
  Array_KSS[Strk_Kss, 2] := 0;
  Array_KSS[Strk_Kss, 3] := 0;

  inc(Strk_Kss); // Приращение строк в массиве
  SetLength(Array_KSS, Strk_Kss, 8);

  form5.ShowModal;

end;

procedure TForm1.btHideFBClick(Sender: TObject);
begin
  Frame21.Flag_Kont := True;
  Frame21.Flag_Lu_St := True;
  Frame21.Flag_Lu_End := True;
  Frame21.Flag_Body := True;
  Frame21.Flag_Plos := True;
  Frame21.Flag_Fotom := False;
  Frame21.Render;
  btHideFB.Visible := False;
end;

procedure TForm1.btDeleteAllClick(Sender: TObject);
var
  buttonSelected: integer;
begin
  buttonSelected := MessageDlg('Удалить?', mtConfirmation, [mbOK, mbCancel], 0);
  if buttonSelected = mrOk then
  begin
    PointsArray := nil;
    PointsArray2 := nil;
    Points_ALL := nil;
    Light_Array := nil;
    Plosk_Array := nil;
    Array_Trass_End := nil;
    Array_Fotom := nil;
    Array_Fotom_Body := nil;
    Array_Fotom_End := nil;
    Array_Fotom_Exp := nil;
    Array_Fotom_End_2 := nil;
    Array_Fotom_End_3 := nil;
    Array_Fotom_End_20 := nil;
    Array_KSS := nil;
    Array_Osvet := nil;
    Frame21.Render;
  end;
end;

procedure TForm1.btCancelClick(Sender: TObject);
begin
  TraceWorking := False;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  D_a, D_b, Rez, rez_Sunn, Svet, Sila, Svet_Summ, ReSvet: double;
  A, B, i, j, nx: integer;
  //
  i1, i12, I5: integer;
  x, y, z, xx, yy, zz, xx2, yy2, zz2: double;
  Mat_Rot: array [1 .. 3, 1 .. 3] of double;
  Alf: double;
  x_A, y_A, z_A: double;
begin
  A := strtoint(Edit3.Text);
  B := 15;

  D_a := 90;
  D_b := 0;

  Strk_Fotom_End := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End, 250000, 15);

  RaTaTa := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End_2, 250000, 15);

  RaTaTa_3 := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End_3, 250000, 15);

  ReSvet := 0;
  for j := 0 to (90 div A) - 1 do
  begin
    D_b := 0;
    for i := 0 to (360 div B) - 1 do
    begin
      Svet_Summ := 0;
      nx := 0;
      for I5 := 0 to (Strk_End) - 1 do
      begin
        if (abs(Array_Trass_End[I5, 11]) > D_a) and
          (abs(Array_Trass_End[I5, 11]) < D_a + A) and
          (abs(Array_Trass_End[I5, 12]) > D_b) and
          (abs(Array_Trass_End[I5, 12]) < D_b + B) then
        begin
          Svet_Summ := Svet_Summ + Array_Trass_End[nx, 8];
          inc(nx);
        end;
      end;

      Array_Fotom_End[Strk_Fotom_End - 1, 1] := D_a + (A / 2);
      Array_Fotom_End[Strk_Fotom_End - 1, 2] := D_b;
      Array_Fotom_End[Strk_Fotom_End - 1, 3] := Svet_Summ;
      Array_Fotom_End[Strk_Fotom_End - 1, 4] := Svet_Summ *
        (sin(DegToRad(D_a + (A / 2))) * DegToRad(A) * DegToRad(B));
      // ReSvet := ReSvet + Array_Fotom_End[Strk_Fotom_End - 1, 4];

      // memo1.Lines.Add(FloatToStr(RoundTo(Array_Fotom_End[Strk_Fotom_End-1, 1], -4))+' '+
      // FloatToStr(RoundTo(Array_Fotom_End[Strk_Fotom_End-1, 2], -4))+' '+
      // FloatToStr(RoundTo(Array_Fotom_End[Strk_Fotom_End-1, 3], -4))+' '+
      // FloatToStr(RoundTo((sin(DegToRad(D_a+(A/2)))*DegToRad(A)*DegToRad(B)), -5))+' '+
      // FloatToStr(RoundTo(Array_Fotom_End[Strk_Fotom_End-1, 4], -5))+' '+
      // IntToStr(nx));

      if (abs(Array_Fotom_End[i, 2]) = 90) then
      begin
        Array_Fotom_End_2[RaTaTa - 1, 1] := Array_Fotom_End
          [Strk_Fotom_End - 1, 1];
        Array_Fotom_End_2[RaTaTa - 1, 2] := Array_Fotom_End
          [Strk_Fotom_End - 1, 2];
        Array_Fotom_End_2[RaTaTa - 1, 3] := Array_Fotom_End
          [Strk_Fotom_End - 1, 3];

        Array_Fotom_End_2[RaTaTa - 1, 4] := Array_Fotom_End[Strk_Fotom_End - 1,
          3] * sin(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 1])) *
          sin(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 2]));
        Array_Fotom_End_2[RaTaTa - 1, 5] := Array_Fotom_End[Strk_Fotom_End - 1,
          3] * sin(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 1])) *
          cos(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 2]));
        Array_Fotom_End_2[RaTaTa - 1, 6] := Array_Fotom_End[Strk_Fotom_End - 1,
          3] * cos(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 1]));

        RaTaTa := RaTaTa + 1;
        // SetLength(Array_Fotom_End_2, RaTaTa, 15);
      end;
      // сортировка для ксс
      if (abs(Array_Fotom_End[i, 2]) = 270) then
      begin
        Array_Fotom_End_3[RaTaTa_3 - 1, 1] := Array_Fotom_End
          [Strk_Fotom_End - 1, 1];
        Array_Fotom_End_3[RaTaTa_3 - 1, 2] := Array_Fotom_End
          [Strk_Fotom_End - 1, 2];
        Array_Fotom_End_3[RaTaTa_3 - 1, 3] := Array_Fotom_End
          [Strk_Fotom_End - 1, 3];

        Array_Fotom_End_3[RaTaTa_3 - 1, 4] := Array_Fotom_End
          [Strk_Fotom_End - 1, 3] *
          sin(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 1])) *
          sin(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 2]));
        Array_Fotom_End_3[RaTaTa_3 - 1, 5] := Array_Fotom_End
          [Strk_Fotom_End - 1, 3] *
          sin(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 1])) *
          cos(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 2]));
        Array_Fotom_End_3[RaTaTa_3 - 1, 6] := Array_Fotom_End
          [Strk_Fotom_End - 1, 3] *
          cos(DegToRad(Array_Fotom_End[Strk_Fotom_End - 1, 1]));

        RaTaTa_3 := RaTaTa_3 + 1;
        // SetLength(Array_Fotom_End_3, RaTaTa_3, 15);
      end;

      D_b := D_b + B;
      Strk_Fotom_End := Strk_Fotom_End + 1; // Приращение строк в массиве
      // SetLength(Array_Fotom_End, Strk_Fotom_End, 15);
    end;
    D_a := D_a + A;
  end;
  // ShowMessage(FloatToStr(RoundTo(ReSvet, -5)));

end;

// подключение к компас (надо переписать, чтоб просто ссылка была на процедуру
procedure TForm1.btReconnectClick(Sender: TObject);
begin
  connected := True;
  try
    kompas := KompasObject(GetActiveOleObject('Kompas.Application.5'));
    Document3D := ksDocument3D(kompas.Document3D());
    Part := ksPart(Document3D.GetPart(pTop_Part));
    try
      Document3D := ksDocument3D(kompas.ActiveDocument3D);
      Part := ksPart(Document3D.GetPart(pTop_Part));
    Except
      ShowMessage('Документ не является деталью или сборкой');
      StatusBar1.Panels[0].Text := 'Компас не подключен';
      connected := False;
    end;
  Except
    ShowMessage('Компас не запущен');
    StatusBar1.Panels[0].Text := 'Компас не запущен';
    connected := False;
  end;
  if connected then
    StatusBar1.Panels[0].Text := 'Компас подключен';
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  N6.Click;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  N7.Click;
end;

procedure TForm1._Fotom_BodyClick(Sender: TObject);
var
  D_a, D_b, Rez, rez_Sunn, Svet, Sila, Svet_Summ, ReSvet, ggg: double;
  A, B, i, j, nx: integer;
  i1, i12, I5: integer;
begin
  // Deg_1_KSS, Deg_2_KSS

  A := strtoint(Edit3.Text);
  B := 5;

  ReSvet := 0;

  D_a := 90;
  D_b := 0;

  Strk_Fotom_End := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End, 999999, 15);
  for j := 0 to (90 div A) - 1 do
  begin
    D_b := 0;
    for i := 0 to (360 div B) - 1 do
    begin
      Svet_Summ := 0;
      nx := 0;
      for I5 := 0 to (Strk_End) - 1 do
      begin
        if (abs(Array_Trass_End[I5, 11]) > D_a) and
          (abs(Array_Trass_End[I5, 11]) < D_a + A) and
          (abs(Array_Trass_End[I5, 12]) > D_b) and
          (abs(Array_Trass_End[I5, 12]) < D_b + B) then
        begin
          Svet_Summ := Svet_Summ + Array_Trass_End[I5, 8];
          inc(nx);
        end;
      end;


      // ggg:= (Svet_Summ / nx);

      Array_Fotom_End[Strk_Fotom_End - 1, 1] := D_a + (A / 2);
      Array_Fotom_End[Strk_Fotom_End - 1, 2] := D_b;
      Array_Fotom_End[Strk_Fotom_End - 1, 3] := (Svet_Summ);

      // Array_Fotom_End[Strk_Fotom_End-1, 3]:=(Svet_Summ ) /  ;

      ReSvet := ReSvet + Array_Fotom_End[Strk_Fotom_End - 1, 3];

      // memo1.Lines.Add(floattostr(Svet_Summ)+' '+Floattostr(ReSvet)+' '+Floattostr((sin(DegToRad(D_a+(A/2)))*DegToRad(A)*DegToRad(B)) ));

      D_b := D_b + B;

      inc(Strk_Fotom_End); // Приращение строк в массиве
      // SetLength(Array_Fotom_End, Strk_Fotom_End, 15);
    end;

    Array_Fotom_End[Strk_Fotom_End - 1, 1] := D_a + (A / 2);
    Array_Fotom_End[Strk_Fotom_End - 1, 2] := 360;
    Array_Fotom_End[Strk_Fotom_End - 1, 3] := Svet_Summ;
    inc(Strk_Fotom_End);

    D_a := D_a + A;
  end;

  dec(Strk_Fotom_End); // Приращение строк в массиве
  SetLength(Array_Fotom_End, Strk_Fotom_End, 15);


  // showmessage(floattostr(ReSvet));

  D_a := 90;
  D_b := 0;

  RaTaTa := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End_2, 250000, 15);

  RaTaTa_3 := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End_3, 250000, 15);

  RaTaTa_20 := 1;

  // for i5 := 0 to (90 div A) do
  // begin
  // D_b:=0;
  for i := 0 to Strk_Fotom_End - 1 do
  begin
    // if (Array_Fotom_End[RaTaTa_20-1, 1] = D_a+(A/2)) and
    // (Array_Fotom_End[RaTaTa_20-1, 2] = D_b) then
    begin
      // Array_Fotom_End_20[RaTaTa_20-1, 1]:=Array_Fotom_End[RaTaTa_20-1, 3] * sin(DegToRad(Array_Fotom_End[RaTaTa_20-1, 1])) * sin(DegToRad(Array_Fotom_End[RaTaTa_20-1, 2])) ;
      // Array_Fotom_End_20[RaTaTa_20-1, 2]:=Array_Fotom_End[RaTaTa_20-1, 3] * sin(DegToRad(Array_Fotom_End[RaTaTa_20-1, 1])) * cos(DegToRad(Array_Fotom_End[RaTabebTa_20-1, 2])) ;
      // Array_Fotom_End_20[RaTaTa_20-1, 3]:=Array_Fotom_End[RaTaTa_20-1, 3] * cos(DegToRad(Array_Fotom_End[RaTaTa_20-1, 1])) ;

    end;

    if trunc((abs(Array_Fotom_End[i, 2]))) = Deg_1_KSS then
    begin
      Array_Fotom_End_2[RaTaTa - 1, 1] := Array_Fotom_End[i, 1];
      Array_Fotom_End_2[RaTaTa - 1, 2] := Array_Fotom_End[i, 2];
      Array_Fotom_End_2[RaTaTa - 1, 3] := Array_Fotom_End[i, 3];

      Array_Fotom_End_2[RaTaTa - 1, 4] := Array_Fotom_End[i, 3] *
        sin(DegToRad(Array_Fotom_End[i, 1])) *
        sin(DegToRad(Array_Fotom_End[i, 2]));
      Array_Fotom_End_2[RaTaTa - 1, 5] := Array_Fotom_End[i, 3] *
        sin(DegToRad(Array_Fotom_End[i, 1])) *
        cos(DegToRad(Array_Fotom_End[i, 2]));
      Array_Fotom_End_2[RaTaTa - 1, 6] := Array_Fotom_End[i, 3] *
        cos(DegToRad(Array_Fotom_End[i, 1]));

      RaTaTa := RaTaTa + 1;
    end;
    // сортировка для ксс
    if trunc((abs(Array_Fotom_End[i, 2]))) = Deg_2_KSS then
    begin
      Array_Fotom_End_3[RaTaTa_3 - 1, 1] := Array_Fotom_End[i, 1];
      Array_Fotom_End_3[RaTaTa_3 - 1, 2] := Array_Fotom_End[i, 2];
      Array_Fotom_End_3[RaTaTa_3 - 1, 3] := Array_Fotom_End[i, 3];

      Array_Fotom_End_3[RaTaTa_3 - 1, 4] := Array_Fotom_End[i, 3] *
        sin(DegToRad(Array_Fotom_End[i, 1])) *
        sin(DegToRad(Array_Fotom_End[i, 2]));
      Array_Fotom_End_3[RaTaTa_3 - 1, 5] := Array_Fotom_End[i, 3] *
        sin(DegToRad(Array_Fotom_End[i, 1])) *
        cos(DegToRad(Array_Fotom_End[i, 2]));
      Array_Fotom_End_3[RaTaTa_3 - 1, 6] := Array_Fotom_End[i, 3] *
        cos(DegToRad(Array_Fotom_End[i, 1]));

      RaTaTa_3 := RaTaTa_3 + 1;
    end;

    // inc(RaTaTa_20);
    // D_b:=D_b+B;
  end;
  // D_a:=D_a+A;
  // end;

  RaTaTa_20 := 1; // Приращение строк в массиве
  SetLength(Array_Fotom_End_20, Strk_Fotom_End * 5, 15);

  D_a := 90;
  D_b := 0;

  for I5 := 0 to (90 div A) - 1 do
  begin
    D_b := 0;
    for i := 0 to (360 div B) - 1 do
    begin
      // 1
      j := 0;
      for j := 0 to Strk_Fotom_End - 1 do
      begin
        if (Array_Fotom_End[j, 1] = D_a + (A / 2)) and
          (Array_Fotom_End[j, 2] = D_b) then
        begin
          Array_Fotom_End_20[RaTaTa_20 - 1, 1] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            sin(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 2] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            cos(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 3] := Array_Fotom_End[j, 3] *
            cos(DegToRad(Array_Fotom_End[j, 1]));
          inc(RaTaTa_20); // Приращение строк в массиве
          // SetLength(Array_Fotom_End_20, RaTaTa_20, 15);
        end;
      end;
      // 2
      j := 0;
      for j := 0 to Strk_Fotom_End - 1 do
      begin
        if (Array_Fotom_End[j, 1] = D_a + (A / 2) + A) and
          (Array_Fotom_End[j, 2] = D_b) then
        begin
          Array_Fotom_End_20[RaTaTa_20 - 1, 1] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            sin(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 2] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            cos(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 3] := Array_Fotom_End[j, 3] *
            cos(DegToRad(Array_Fotom_End[j, 1]));
          inc(RaTaTa_20); // Приращение строк в массиве
          // SetLength(Array_Fotom_End_20, RaTaTa_20, 15);
        end;
      end;
      // 3
      j := 0;
      for j := 0 to Strk_Fotom_End - 1 do
      begin
        if (Array_Fotom_End[j, 1] = D_a + (A / 2) + A) and
          (Array_Fotom_End[j, 2] = D_b + B) then
        begin
          Array_Fotom_End_20[RaTaTa_20 - 1, 1] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            sin(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 2] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            cos(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 3] := Array_Fotom_End[j, 3] *
            cos(DegToRad(Array_Fotom_End[j, 1]));
          inc(RaTaTa_20); // Приращение строк в массиве
          // SetLength(Array_Fotom_End_20, RaTaTa_20, 15);
        end;
      end;
      // 4
      j := 0;
      for j := 0 to Strk_Fotom_End - 1 do
      begin
        if (Array_Fotom_End[j, 1] = D_a + (A / 2)) and
          (Array_Fotom_End[j, 2] = D_b + B) then
        begin
          Array_Fotom_End_20[RaTaTa_20 - 1, 1] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            sin(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 2] := Array_Fotom_End[j, 3] *
            sin(DegToRad(Array_Fotom_End[j, 1])) *
            cos(DegToRad(Array_Fotom_End[j, 2]));
          Array_Fotom_End_20[RaTaTa_20 - 1, 3] := Array_Fotom_End[j, 3] *
            cos(DegToRad(Array_Fotom_End[j, 1]));
          inc(RaTaTa_20); // Приращение строк в массиве
          // SetLength(Array_Fotom_End_20, RaTaTa_20, 15);
        end;
      end;
      D_b := D_b + B;
    end;
    D_a := D_a + A;
  end;

  dec(RaTaTa_20); // Приращение строк в массиве
  SetLength(Array_Fotom_End_20, RaTaTa_20, 15);

  dec(RaTaTa); // Приращение строк в массиве
  SetLength(Array_Fotom_End_2, RaTaTa, 15);

  dec(RaTaTa_3); // Приращение строк в массиве
  SetLength(Array_Fotom_End_3, RaTaTa, 15);

end;

procedure TForm1.Fibanachi_V(n, n_2: integer; Fi: double);
var
  k, j, Strk_Sin, k1, Kt: integer;
  d_V, v, sum, F_sv, Random_1, Random_2, Shag_1, Shag, F_Svett: double;
  Array_Sin: Array of Array of single;
  Array_Const: Array [1 .. 36] of double;
  i: integer;
begin
  // memo1.Clear;
  d_V := 5;
  v := 90;
  Kt := 0;

  Array_Const[1] := 0.0072934;
  Array_Const[2] := 0.0145312;
  Array_Const[3] := 0.0216585;
  Array_Const[4] := 0.0286209;
  Array_Const[5] := 0.0353655;
  Array_Const[6] := 0.041841;
  Array_Const[7] := 0.047998;
  Array_Const[8] := 0.0537898;
  Array_Const[9] := 0.0591721;
  Array_Const[10] := 0.0641041;
  Array_Const[11] := 0.0685483;
  Array_Const[12] := 0.0724707;
  Array_Const[13] := 0.0758417;
  Array_Const[14] := 0.0786354;
  Array_Const[15] := 0.0808306;
  Array_Const[16] := 0.0824107;
  Array_Const[17] := 0.0833636;
  Array_Const[18] := 0.083682;

  Array_Const[36] := 0.0072934;
  Array_Const[35] := 0.0145312;
  Array_Const[34] := 0.0216585;
  Array_Const[33] := 0.0286209;
  Array_Const[32] := 0.0353655;
  Array_Const[31] := 0.041841;
  Array_Const[30] := 0.047998;
  Array_Const[29] := 0.0537898;
  Array_Const[28] := 0.0591721;
  Array_Const[27] := 0.0641041;
  Array_Const[26] := 0.0685483;
  Array_Const[25] := 0.0724707;
  Array_Const[24] := 0.0758417;
  Array_Const[23] := 0.0786354;
  Array_Const[22] := 0.0808306;
  Array_Const[21] := 0.0824107;
  Array_Const[20] := 0.0833636;
  Array_Const[19] := 0.083682;


  // F_sv:=strtoint(edit2.Text)/(n*n_2);

  Strk_Sin := 1;
  SetLength(Array_Sin, (Floor(180 / d_V) + 1), 10);

  for j := 0 to Floor(180 / d_V) - 1 do
  begin
    Array_Sin[Strk_Sin - 1, 1] := cos(DegToRad(v - d_V));
    Array_Sin[Strk_Sin - 1, 2] := Array_Const[j + 1] * (n / 2);
    v := v - d_V;
    inc(Strk_Sin);
  end;

  Randomize;

  v := 90;

  case CheckBox1.Checked of
    True:
      F_Svett := strtoint(Edit2.Text) * Kol_Ist;
    False:
      F_Svett := strtoint(Edit2.Text);
  end;

  for k := 0 to Floor(180 / d_V) - 1 do
  begin
    F_sv := (((159.16 / (n_2 * 2)) * Array_Const[k + 1]) /
      roundto(Array_Sin[k, 2], 0)) * ((F_Svett / 1000));
    Shag_1 := 0;
    for k1 := 0 to Floor(roundto(Array_Sin[k, 2], 0)) - 1 do
    begin
      if Kt >= Strk2 - 1 then
      begin
        Kt := 0;
        Random_1 := Random(4);
        // Random_2:=Random(3);
        Shag := 5 / Floor((Array_Sin[k, 2]));
        Shag_1 := Shag_1 + Shag;

        Light_Array[Strk_L - 1, 1] := PointsArray2[Kt, 1];
        Light_Array[Strk_L - 1, 2] := PointsArray2[Kt, 2];
        Light_Array[Strk_L - 1, 3] := PointsArray2[Kt, 3];

        Light_Array[Strk_L - 1, 4] := PointsArray2[Kt, 1] + 50 *
          sin(DegToRad(v + Shag_1)) * sin(DegToRad(Fi + Random_1));
        Light_Array[Strk_L - 1, 5] := PointsArray2[Kt, 2] + 50 *
          sin(DegToRad(v + Shag_1)) * cos(DegToRad(Fi + Random_1));
        Light_Array[Strk_L - 1, 6] := PointsArray2[Kt, 3] + 50 *
          cos(DegToRad(v + Shag_1));

        Light_Array[Strk_L - 1, 7] := F_sv;

        Kt := Kt + 1;
        inc(Strk_L);
      end
      else
      begin
        Random_1 := Random(4);
        // Random_2:=Random(3);
        Shag := 5 / Floor((Array_Sin[k, 2]));
        Shag_1 := Shag_1 + Shag;

        Light_Array[Strk_L - 1, 1] := PointsArray2[Kt, 1];
        Light_Array[Strk_L - 1, 2] := PointsArray2[Kt, 2];
        Light_Array[Strk_L - 1, 3] := PointsArray2[Kt, 3];

        Light_Array[Strk_L - 1, 4] := PointsArray2[Kt, 1] + 50 *
          sin(DegToRad(v + Shag_1)) * sin(DegToRad(Fi + Random_1));
        Light_Array[Strk_L - 1, 5] := PointsArray2[Kt, 2] + 50 *
          sin(DegToRad(v + Shag_1)) * cos(DegToRad(Fi + Random_1));
        Light_Array[Strk_L - 1, 6] := PointsArray2[Kt, 3] + 50 *
          cos(DegToRad(v + Shag_1));

        Light_Array[Strk_L - 1, 7] := F_sv;

        Kt := Kt + 1;
        inc(Strk_L);
      end;
    end;
    v := v + d_V;
  end;
end;

procedure TForm1.Fibanachi_V_m(n, n_2: integer; Fi: double);
var
  k, j, Strk_Sin, k1, Kt, typeOfIliium, TriangCount, raysCount: integer;
  dx, dy, dz, fi777, psi: double;
  d_V, v, sum, F_sv, F_Svett: double;
  i: integer;
begin
  Randomize;
  d_V := 5;
  v := 90;
  Kt := 0;

  for k := 0 to Floor(180 / d_V) - 1 do
  begin
    for k1 := 0 to 20 { Floor(roundto(Array_Sin[k, 2], 0)) - 1 } do
    begin
      if Kt >= Strk2 - 1 then
        Kt := 0;

      // прописываем начало луча - перавая точка треугольника:
      Light_Array[Strk_L - 1, 1] := PointsArray2[Kt, 1];
      Light_Array[Strk_L - 1, 2] := PointsArray2[Kt, 2];
      Light_Array[Strk_L - 1, 3] := PointsArray2[Kt, 3];

      // Считаем вектор нормали:
      dx := PointsArray2[i, 8];
      dy := PointsArray2[i, 9];
      dz := PointsArray2[i, 10];
      fi777 := ArcCos(dz / sqrt(dx * dx + dy * dy + dz * dz));
      psi := ArcTan(dx / dy);

      if cbInvert.Checked = True then
        fi777 := pi() + fi777;

      // записываем в массив конец луча  (определяющий по сути направление)
      // В зависимости от выбранного режима
      case 0 of
        0:
          begin
            Light_Array[Strk_L - 1, 4] := PointsArray2[Kt, 1] + 50 *
              sin(fi777 + pi() / 2 + pi() * Random) *
              sin(psi + pi() / 2 + pi() * Random);
            Light_Array[Strk_L - 1, 5] := PointsArray2[Kt, 2] + 50 *
              sin(fi777 + pi() / 2 + pi() * Random) *
              cos(psi + pi() / 2 + pi() * Random);
            Light_Array[Strk_L - 1, 6] := PointsArray2[Kt, 3] + 50 *
              cos(fi777 + pi() / 2 + pi() * Random);
            {
              Light_Array[Strk_L - 1, 4] := PointsArray2[Kt, 1] + 50 *sin(DegToRad(v + Shag_1)) * sin(DegToRad(Fi + Random_1));
              Light_Array[Strk_L - 1, 5] := PointsArray2[Kt, 2] + 50 *sin(DegToRad(v + Shag_1)) * cos(DegToRad(Fi + Random_1));
              Light_Array[Strk_L - 1, 6] := PointsArray2[Kt, 3] + 50 *cos(DegToRad(v + Shag_1));
            }
          end;
        1:
          ;
        2:
          ;
      end;

      if CheckBox1.Checked then
        F_Svett := strtoint(Edit2.Text) * Kol_Ist
      else
        F_Svett := strtoint(Edit2.Text);
      F_sv := F_Svett / 1000; { (((159.16 / (n_2 * 2)) * Array_Const[k + 1]) /
        roundto(Array_Sin[k, 2], 0)) * ((F_Svett / 1000)); }
      Light_Array[Strk_L - 1, 7] := F_sv;

      Kt := Kt + 1;
      inc(Strk_L);
    end
  end;
  v := v + d_V;

  {
    // тип излучения (косинусное, направленно-рассеянное - на будущее)
    typeOfIliium := 1;

    raysCount := 100000; // high(Light_Array);
    TriangCount := 3;

    if CheckBox1.Checked then
    F_Svett := strtoint(Edit2.Text) * Kol_Ist
    else
    F_Svett := strtoint(Edit2.Text);

    k := 1;
    for i := 0 to TriangCount do
    begin
    for j := 0 to Floor(raysCount / TriangCount) do
    // нужно будет исправить, чтоб учитывался размер треугольника
    begin
    Randomize;
    Random_1 := Random;
    Random_2 := Random;
    Random_3 := Random;
    // прописываем начало луча - перавая точка треугольника:
    dx := PointsArray2[i, 8] - PointsArray2[i, 1];
    dy := PointsArray2[i, 9] - PointsArray2[i, 2];
    dz := PointsArray2[i, 10] - PointsArray2[i, 3];

    Light_Array[k, 1] := 1;//PointsArray2[i, 1];
    Light_Array[k, 2] := 1;//PointsArray2[i, 2];
    Light_Array[k, 3] := 1;//PointsArray2[i, 3];
    // Считаем вектор нормали:
    fi777 := ArcCos(dz / sqrt(dx * dx + dy * dy + dz * dz));
    psi := ArcTan(dx / dy);
    // записываем в массив конец луча  (определяющий по сути направление)
    Light_Array[k, 4] := 1;//PointsArray2[i, 1] + 50 * sin(fi777) * sin(psi);
    Light_Array[k, 5] := 1;//PointsArray2[i, 1] + 50 * sin(fi777) * cos(psi);
    Light_Array[k, 6] := 1;//PointsArray2[i, 1] + 50 * cos(fi777);

    // Записывваем поток луча:

    Light_Array[k, 7] :=  1;//F_Svett / raysCount;

    inc(k);
    end;
    end;
    while k < raysCount do // дозаполнить  массив пустыми значениями
    begin
    for i := 0 to 7 do
    Light_Array[k, i] := 0.00000001;
    inc(k);
    end;
  }
end;

{ TMyThread }

procedure TMyThread.Execute;
var
  i, Cur_I: integer;
begin

  // ShowMessage('Запустился поток');

  // for I := 0 to Strk_L-2 do
  while TraceWorking do
  begin
    CS.Enter;
    try
      inc(Cur);
      if (Cur < Strk_L - 1) then
        Cur_I := Cur
      else
        TraceWorking := False;
    finally
      CS.Leave;
    end;

    if TraceWorking then
    begin
      Rez1 := Form1.Trass(Light_Array[Cur_I - 1, 1], Light_Array[Cur_I - 1, 2],
        Light_Array[Cur_I - 1, 3], Light_Array[Cur_I - 1, 4],
        Light_Array[Cur_I - 1, 5], Light_Array[Cur_I - 1, 6],
        Light_Array[Cur_I - 1, 7]);
      n := 1;
      synchronize(Live_Lu);

      // 2
      if Flag_Rez then
      begin
        Svet_Pottok := Array_Trass_End[Strk_End - 2, 8];
        // -2 потому что в функции записи стрк приращается дополнительно на еденицу

        Rez_Otr1 := Form1.Otr(Rez1[1], Rez1[2], Rez1[3], Rez1[4], Rez1[5],
          Rez1[6], Rez1[13], Rez1[14], Rez1[15]);
        Rez1 := Form1.Trass(Rez_Otr1[1], Rez_Otr1[2], Rez_Otr1[3], Rez_Otr1[4],
          Rez_Otr1[5], Rez_Otr1[6], Svet_Pottok);
        n := 2;
        synchronize(Live_Lu);
      end;
      // 3
      if Flag_Rez then
      begin
        Svet_Pottok := Array_Trass_End[Strk_End - 2, 8];
        // -2 потому что в функции записи стрк приращается дополнительно на еденицу

        Rez_Otr1 := Form1.Otr(Rez1[1], Rez1[2], Rez1[3], Rez1[4], Rez1[5],
          Rez1[6], Rez1[13], Rez1[14], Rez1[15]);
        Rez1 := Form1.Trass(Rez_Otr1[1], Rez_Otr1[2], Rez_Otr1[3], Rez_Otr1[4],
          Rez_Otr1[5], Rez_Otr1[6], Svet_Pottok);
        n := 3;
        synchronize(Live_Lu);
      end;
      // 4
      if Flag_Rez then
      begin
        Svet_Pottok := Array_Trass_End[Strk_End - 2, 8];
        // -2 потому что в функции записи стрк приращается дополнительно на еденицу

        Rez_Otr1 := Form1.Otr(Rez1[1], Rez1[2], Rez1[3], Rez1[4], Rez1[5],
          Rez1[6], Rez1[13], Rez1[14], Rez1[15]);
        Rez1 := Form1.Trass(Rez_Otr1[1], Rez_Otr1[2], Rez_Otr1[3], Rez_Otr1[4],
          Rez_Otr1[5], Rez_Otr1[6], Svet_Pottok);
        n := 4;
        synchronize(Live_Lu);
      end;
      // 5
      if Flag_Rez then
      begin
        Svet_Pottok := Array_Trass_End[Strk_End - 2, 8];
        // -2 потому что в функции записи стрк приращается дополнительно на еденицу

        Rez_Otr1 := Form1.Otr(Rez1[1], Rez1[2], Rez1[3], Rez1[4], Rez1[5],
          Rez1[6], Rez1[13], Rez1[14], Rez1[15]);
        Rez1 := Form1.Trass(Rez_Otr1[1], Rez_Otr1[2], Rez_Otr1[3], Rez_Otr1[4],
          Rez_Otr1[5], Rez_Otr1[6], Svet_Pottok);
        n := 5;
        synchronize(Live_Lu);
      end;
      // 6
      if Flag_Rez then
      begin
        Svet_Pottok := Array_Trass_End[Strk_End - 2, 8];
        // -2 потому что в функции записи стрк приращается дополнительно на еденицу

        Rez_Otr1 := Form1.Otr(Rez1[1], Rez1[2], Rez1[3], Rez1[4], Rez1[5],
          Rez1[6], Rez1[13], Rez1[14], Rez1[15]);
        Rez1 := Form1.Trass(Rez_Otr1[1], Rez_Otr1[2], Rez_Otr1[3], Rez_Otr1[4],
          Rez_Otr1[5], Rez_Otr1[6], Svet_Pottok);
        n := 6;
        synchronize(Live_Lu);
      end;
      // 7
      if Flag_Rez then
      begin
        Svet_Pottok := Array_Trass_End[Strk_End - 2, 8];
        // -2 потому что в функции записи стрк приращается дополнительно на еденицу

        Rez_Otr1 := Form1.Otr(Rez1[1], Rez1[2], Rez1[3], Rez1[4], Rez1[5],
          Rez1[6], Rez1[13], Rez1[14], Rez1[15]);
        Rez1 := Form1.Trass(Rez_Otr1[1], Rez_Otr1[2], Rez_Otr1[3], Rez_Otr1[4],
          Rez_Otr1[5], Rez_Otr1[6], Svet_Pottok);
        n := 7;
        synchronize(Live_Lu);
      end;
    end;

  end;

end;

procedure TMyThread.Live_Lu;
var
  x_A, y_A, z_A, Fi: double;
begin
  if (Floor(Rez1[7]) = 3) or (Floor(Rez1[7]) = -1) then
  begin
    x_A := Rez1[4] - Rez1[1];
    y_A := Rez1[5] - Rez1[2];
    z_A := Rez1[6] - Rez1[3];
    Fi := (RadToDeg(ArcTan2(y_A, x_A)));

    Array_Trass_End[Strk_End - 1, 1] := Rez1[1];
    Array_Trass_End[Strk_End - 1, 2] := Rez1[2];
    Array_Trass_End[Strk_End - 1, 3] := Rez1[3];
    Array_Trass_End[Strk_End - 1, 4] := Rez1[4];
    Array_Trass_End[Strk_End - 1, 5] := Rez1[5];
    Array_Trass_End[Strk_End - 1, 6] := Rez1[6];
    Array_Trass_End[Strk_End - 1, 7] := n; // жизнь (отражение)
    Array_Trass_End[Strk_End - 1, 8] := Rez1[12]; // световой поток
    Array_Trass_End[Strk_End - 1, 9] := 0;
    // 0 - конец, 1- продолжается отражение, 3 - умер на источнике излучения.
    Array_Trass_End[Strk_End - 1, 10] := Rez1[11];

    Array_Trass_End[Strk_End - 1, 11] :=
      (RadToDeg(ArcCos(z_A / (sqrt(sqr(x_A) + sqr(y_A) + sqr(z_A))))));
    if Fi < 0 then
    begin
      Array_Trass_End[Strk_End - 1, 12] := 360 + Fi;
    end
    else
    begin
      Array_Trass_End[Strk_End - 1, 12] := Fi;
    end;

    inc(Strk_End);
    // SetLength(Array_Trass_End, Strk_End, 15);
    Flag_Rez := False;
  end;

  if (Floor(Rez1[7]) = 1) then
  begin
    Array_Trass_End[Strk_End - 1, 1] := Rez1[1];
    Array_Trass_End[Strk_End - 1, 2] := Rez1[2];
    Array_Trass_End[Strk_End - 1, 3] := Rez1[3];
    Array_Trass_End[Strk_End - 1, 4] := Rez1[4];
    Array_Trass_End[Strk_End - 1, 5] := Rez1[5];
    Array_Trass_End[Strk_End - 1, 6] := Rez1[6];
    Array_Trass_End[Strk_End - 1, 7] := n; // жизнь (отражение)
    Array_Trass_End[Strk_End - 1, 8] := Rez1[12] * Rez1[8];
    // световой поток
    // Array_Trass_End[Strk_End-1 ,8]:=Rez[12];   // световой поток
    Array_Trass_End[Strk_End - 1, 9] := 1;
    // 0 - конец, 1- продолжается отражение, 3 - умер на источнике излучения.
    Array_Trass_End[Strk_End - 1, 10] := Rez1[11];
    inc(Strk_End);
    // SetLength(Array_Trass_End, Strk_End, 15);
    Flag_Rez := True;
  end;

  if (Floor(Rez1[7]) = 2) then
  begin
    Array_Trass_End[Strk_End - 1, 1] := Rez1[1];
    Array_Trass_End[Strk_End - 1, 2] := Rez1[2];
    Array_Trass_End[Strk_End - 1, 3] := Rez1[3];
    Array_Trass_End[Strk_End - 1, 4] := Rez1[4];
    Array_Trass_End[Strk_End - 1, 5] := Rez1[5];
    Array_Trass_End[Strk_End - 1, 6] := Rez1[6];
    Array_Trass_End[Strk_End - 1, 7] := n; // жизнь (отражение)
    Array_Trass_End[Strk_End - 1, 8] := 0; // световой поток
    Array_Trass_End[Strk_End - 1, 9] := 2;
    // 0 - конец, 1- продолжается отражение, 2 - умер на источнике излучения.
    inc(Strk_End);
    // SetLength(Array_Trass_End, Strk_End, 15);
    Flag_Rez := False;
  end;
  // form1.label1.caption:=  inttostr(Cur) +' из '+ inttostr(Strk_L);
  Form1.Gauge1.Progress := Cur;
end;

end.
