unit Trian_OTR;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Gauges, ksTLB,
  ksConstTLB, math, ComObj;

type
  TForm3 = class(TForm)
    ������: TButton;
    Gauge1: TGauge;
    Edit1: TEdit;
    Memo1: TMemo;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Gauge2: TGauge;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ������Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    abort_loop: boolean;
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit1, unit2;

procedure TForm3.������Click(Sender: TObject);
begin
  abort_loop := FALSE;
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  SelectionMng: ksSelectionMng; // ���������
  Entity: ksEntity; // ���������
  FaceDefinition: ksFaceDefinition; // ���������
  Surface: ksSurface; // ���������
  Tessellation: ksTessellation; // ���������
  ChooseMng: ksChooseMng; // ��������� ��������� ������ (���������)
  Facet: ksFacet; // ��������� ���������������� ��������
  BodyCollection: ksBodyCollection;
  Body: ksBody;
  FaceCollection: ksFaceCollection;
  ColorParam: ksColorParam;

  // ---------------------����������----------------------
  Gx1, Gy1, Gz1, Gx2, Gy2, Gz2, GabX, GabY, GabZ, FacetSize, Mnoj,
  // ��� �������������� ������������
  amb, diff, specul, shin, transp, emis: Double;
  k, i, j, i0, Flag006, FlagPr, i02: Integer;
  nVertexPlast, nPlast, nVertex, color, n_Gran, n_gran_t: Integer;
  // nPlast - ���-�� ���������������� �������
  x1, y1, z1, x2, y2, z2, x3, y3, z3: single; // ���������� ������� � ��������
  GabArray: Array [0 .. 3] of Double;
  Matrix: OleVariant;
  e1x, e1y, e1z, e2x, e2y, e2z: Double;
  // ---------------------���������----------------------
begin
Gauge1.Progress:=0;
  // �������� ��������� ��������� ������ (���������)
  ChooseMng := ksChooseMng(Document3D.GetChooseMng);
  // �������� ��������� ��������� ���������� �������� (���������)
  SelectionMng := ksSelectionMng(Document3D.GetSelectionMng);
  Strk := 0;
  ChooseMng.UnChooseAll;
  Memo1.Clear;
  abort_loop := true;

  for i := 0 to SelectionMng.GetCount - 1 do
  begin
    Entity := ksEntity(SelectionMng.GetObjectByIndex(i));
    FlagPr := Entity.type_;
    if (FlagPr = 6) then
    begin
      FaceDefinition := ksFaceDefinition(Entity.GetDefinition);
      Surface := ksSurface(FaceDefinition.GetSurface);
      Tessellation := ksTessellation(FaceDefinition.GetTessellation);
      Facet := ksFacet(Tessellation.GetFacet());
      Surface.GetGabarit(Gx1, Gy1, Gz1, Gx2, Gy2, Gz2);
      // ��������� ����������� ������������
      GabArray[0] := abs(Gx1 - Gx2); // ������ �������� �� X
      GabArray[1] := abs(Gy1 - Gy2); // ������ �������� �� Y
      GabArray[2] := abs(Gz1 - Gz2); // ������ �������� �� Z
      FacetSize := MaxValue(GabArray); // ���������� ��������
      Tessellation.SetFacetSize(0);
      Tessellation.SetFacetSize(FacetSize * (strtofloat(Edit1.Text) / 100));
      nVertex := Tessellation.GetPointsCount;
      Strk := Strk + nVertex;
      inc(n_Gran);
    end;
    if (FlagPr <> 6) then
    begin
      Matrix := part.GetSummMatrix(SelectionMng.GetObjectByIndex(i));
      part := ksPart(SelectionMng.GetObjectByIndex(i));
      BodyCollection := ksBodyCollection(part.BodyCollection);
      Body := ksBody(BodyCollection.GetByIndex(0));
      FaceCollection := ksFaceCollection(Body.FaceCollection);
      for i02 := 0 to FaceCollection.GetCount - 1 do
      begin
        FaceDefinition := ksFaceDefinition(FaceCollection.GetByIndex(i02));
        Surface := ksSurface(FaceDefinition.GetSurface);
        // �������� ��������� �������������� �����������
        Tessellation := ksTessellation(FaceDefinition.GetTessellation);
        // �������� ��������� ������������ ��������� �����
        Facet := ksFacet(Tessellation.GetFacet());
        Tessellation.SetFacetSize(0);
        nVertex := Tessellation.GetPointsCount;
        Strk := Strk + nVertex;
        inc(n_Gran);
      end;
    end;
  end;

  Gauge1.MinValue := 0;
  Gauge1.MaxValue := n_Gran;
  n_gran_t := 1;

  SetLength(PointsArray, Strk*10, 15);
  Strk := 3;

  for i := 0 to SelectionMng.GetCount - 1 do
  begin
    Entity := ksEntity(SelectionMng.GetObjectByIndex(i));
    FlagPr := Entity.type_;
    if (FlagPr = 6) then
    begin
      Entity := ksEntity(SelectionMng.GetObjectByIndex(i));
      part := ksPart(Entity.GetParent);
      Matrix := part.GetSummMatrix(Entity.GetParent());
      FaceDefinition := ksFaceDefinition(Entity.GetDefinition);
      Surface := ksSurface(FaceDefinition.GetSurface);
      // �������� ��������� �������������� �����������
      Tessellation := ksTessellation(FaceDefinition.GetTessellation);
      // �������� ��������� ������������ ��������� �����
      Facet := ksFacet(Tessellation.GetFacet());
      // �������� ��������� ���������������� ��������
      Surface.GetGabarit(Gx1, Gy1, Gz1, Gx2, Gy2, Gz2);
      // ��������� ����������� ������������
      GabArray[0] := abs(Gx1 - Gx2); // ������ �������� �� X
      GabArray[1] := abs(Gy1 - Gy2); // ������ �������� �� Y
      GabArray[2] := abs(Gz1 - Gz2); // ������ �������� �� Z
      FacetSize := MaxValue(GabArray); // ���������� ��������
      Tessellation.SetFacetSize(0);
      Tessellation := ksTessellation(FaceDefinition.GetTessellation);
      // �������� ��������� ������������ ��������� �����
      Tessellation.SetFacetSize(FacetSize * (strtofloat(Edit1.Text) / 100));
      nPlast := Tessellation.GetFacetsCount; // ���-�� ���������������� �������
      nVertex := Tessellation.GetPointsCount; // ���-�� ������ �� �����
    label1.Caption:='������� - '+ IntToStr(nPlast)+#13#10+       // ������� ���-�� ���������������� �������
                    '������ - '+IntToStr(nVertex)+#13#10+        // � ������ � ���������������� ��������
                    '������ ����� - '+Floattostr(RoundTo(FacetSize, -2))+#13#10+     // � ����� ������ ����� ������������
                    '���-�� ���������� ������ - '+IntToStr(n_Gran);   // � ����� ���-�� ���������� ������
    label3.Caption:='������������ ����������'+' - �����'+' '+ inttostr(n_gran_t)+' '+'��'+' '+ inttostr(n_Gran) ;
    gauge2.MinValue:=0;                                                              // �������� ���
    gauge2.MaxValue:=nPlast-1;
      // ------------------------- ������ ����� ������������ ����� ����� ----------------------
      for j := 0 to nPlast - 1 do // ���� �������� �������
      begin
        Tessellation.GetFacetData(j, Facet);
        // �������� ������ ��������� ��������
        Application.ProcessMessages;
        if (Facet.GetPointsCount = 3) then
        // ���-�� ������ � ���������������� �������� - Facet.GetPointsCount
        begin
          if abort_loop then
          begin
            Facet.GetPoint(0, x1, y1, z1); // ��������� ���������� ������� 1
            Facet.GetPoint(1, x2, y2, z2); // ��������� ���������� ������� 2
            Facet.GetPoint(2, x3, y3, z3); // ��������� ���������� ������� 3
            ColorParam := ksColorParam(part.ColorParam);
            PointsArray[Strk - 3, 1] :=RoundTo((x1 * Matrix[0]) { +(y*matrix[4])+(z*matrix[8]) } +(1 * Matrix[12]), -4); // ������� �������������� 1
            PointsArray[Strk - 3, 2] := { (x*matrix[1])+ } RoundTo((y1 * Matrix[5]) { +(z*matrix[9]) } + (1 * Matrix[13]), -4);   // ������� �������������� 1
            PointsArray[Strk - 3, 3] := { (x*matrix[2])+(y*matrix[6])+ } RoundTo((z1 * Matrix[10]) + (1 * Matrix[14]), -4);   // ������� �������������� 1

            PointsArray[Strk - 2, 1] :=RoundTo((x2 * Matrix[0]) { +(y*matrix[4])+(z*matrix[8]) } +(1 * Matrix[12]), -4); // ������� �������������� 2
            PointsArray[Strk - 2, 2] := { (x*matrix[1])+ } RoundTo((y2 * Matrix[5]) { +(z*matrix[9]) } + (1 * Matrix[13]), -4);   // ������� �������������� 2
            PointsArray[Strk - 2, 3] := { (x*matrix[2])+(y*matrix[6])+ } RoundTo((z2 * Matrix[10]) + (1 * Matrix[14]), -4);   // ������� �������������� 2

            PointsArray[Strk - 1, 1] :=RoundTo((x3 * Matrix[0]) { +(y*matrix[4])+(z*matrix[8]) } +(1 * Matrix[12]), -4); // ������� �������������� 3
            PointsArray[Strk - 1, 2] := { (x*matrix[1])+ } RoundTo((y3 * Matrix[5]) { +(z*matrix[9]) } + (1 * Matrix[13]), -4);    // ������� �������������� 3
            PointsArray[Strk - 1, 3] := { (x*matrix[2])+(y*matrix[6])+ } RoundTo((z3 * Matrix[10]) + (1 * Matrix[14]), -4);      // ������� �������������� 3
            // ------------------------------�������--------------------------------
            e1x := PointsArray[Strk - 2, 1] - PointsArray[Strk - 3, 1];
            e1y := PointsArray[Strk - 2, 2] - PointsArray[Strk - 3, 2];
            e1z := PointsArray[Strk - 2, 3] - PointsArray[Strk - 3, 3];

            e2x := PointsArray[Strk - 1, 1] - PointsArray[Strk - 3, 1];
            e2y := PointsArray[Strk - 1, 2] - PointsArray[Strk - 3, 2];
            e2z := PointsArray[Strk - 1, 3] - PointsArray[Strk - 3, 3];

            PointsArray[Strk - 3, 8] := (e1y * e2z) - (e1z * e2y);

            PointsArray[Strk - 3, 9] := (e1z * e2x) - (e1x * e2z);

            PointsArray[Strk - 3, 10] := (e1x * e2y) - (e1y * e2x);

            PointsArray[Strk - 3, 11] :=
              (PointsArray[Strk - 3, 8] * PointsArray[Strk - 3, 1]) +
              (PointsArray[Strk - 3, 9] * PointsArray[Strk - 3, 2]) +
              (PointsArray[Strk - 3, 10] * PointsArray[Strk - 3, 3]);
            // ------------------------------�������--------------------------------
            PointsArray[Strk - 3, 5] := (ColorParam.specularity);
            PointsArray[Strk - 3, 6] := (ColorParam.diffuse);
            PointsArray[Strk - 3, 7] := (ColorParam.transparency);

            PointsArray[Strk - 3, 4] := 1;

            Strk := Strk + 3; // ���������� ����� � �������
          end
          else
          begin
            Gauge1.Progress := 0;
            exit;
          end;

        end
        else
        begin
          showmessage('���������������� �������� ����� ������ 3 ������');
          exit;
        end;
      gauge2.Progress:=j;
      end;
    Gauge1.Progress := n_gran_t;
    inc(n_gran_t);
    end;

    if (FlagPr <> 6) then
    begin
      part := ksPart(SelectionMng.GetObjectByIndex(i));
      Matrix := part.GetSummMatrix(SelectionMng.GetObjectByIndex(i));
      BodyCollection := ksBodyCollection(part.BodyCollection);
      Body := ksBody(BodyCollection.GetByIndex(0));
      FaceCollection := ksFaceCollection(Body.FaceCollection);
      for i02 := 0 to FaceCollection.GetCount - 1 do
      begin
        FaceDefinition := ksFaceDefinition(FaceCollection.GetByIndex(i02));
        Tessellation := ksTessellation(FaceDefinition.GetTessellation);
        // �������� ��������� ������������ ��������� �����
        Facet := ksFacet(Tessellation.GetFacet());
        Surface := ksSurface(FaceDefinition.GetSurface);
        Entity := ksEntity(FaceDefinition.GetEntity);
        Surface.GetGabarit(Gx1, Gy1, Gz1, Gx2, Gy2, Gz2);
        // ��������� ����������� ������������
        GabArray[0] := abs(Gx1 - Gx2); // ������ �������� �� X
        GabArray[1] := abs(Gy1 - Gy2); // ������ �������� �� Y
        GabArray[2] := abs(Gz1 - Gz2); // ������ �������� �� Z
        FacetSize := MaxValue(GabArray); // ���������� ��������
        Tessellation.SetFacetSize(0);
        Tessellation := ksTessellation(FaceDefinition.GetTessellation);
        // �������� ��������� ������������ ��������� �����
        Tessellation.SetFacetSize(FacetSize);
        nPlast := Tessellation.GetFacetsCount;
        // ���-�� ���������������� �������
        nVertex := Tessellation.GetPointsCount; // ���-�� ������ �� �����
      label1.Caption:='������� - '+ IntToStr(nPlast)+#13#10+       // ������� ���-�� ���������������� �������
                      '������ - '+IntToStr(nVertex)+#13#10+        // � ������ � ���������������� ��������
                      '������ ����� - '+Floattostr(RoundTo(FacetSize, -2))+#13#10+     // � ����� ������ ����� ������������
                      '���-�� ���������� ������ - '+IntToStr(n_Gran);   // � ����� ���-�� ���������� ������
      label3.Caption:='������������ ����������'+' - �����'+' '+ inttostr(n_gran_t)+' '+'��'+' '+ inttostr(n_Gran) ;
      gauge2.MinValue:=0;                                                              // �������� ���
      gauge2.MaxValue:=nPlast-1;
        // ------------------------- ������ ����� ������������ ����� ����� ----------------------
        for j := 0 to nPlast - 1 do // ���� �������� �������
        begin
          Tessellation.GetFacetData(j, Facet);
          // �������� ������ ��������� ��������
          Application.ProcessMessages; // ���-�� ���� ���� ��������
          if (Facet.GetPointsCount = 3)
          // ���-�� ������ � ���������������� �������� - Facet.GetPointsCount
          then
          begin
            if abort_loop then
            begin
              Facet.GetPoint(0, x1, y1, z1); // ��������� ���������� ������� 1
              Facet.GetPoint(1, x2, y2, z2); // ��������� ���������� ������� 2
              Facet.GetPoint(2, x3, y3, z3); // ��������� ���������� ������� 3
              ColorParam := ksColorParam(part.ColorParam);

              PointsArray[Strk - 3, 1] := RoundTo((x1 * Matrix[0]) { +(y*matrix[4])+(z*matrix[8]) } + (1 * Matrix[12]), -4); // ������� �������������� 1
              PointsArray[Strk - 3, 2] := { (x*matrix[1])+ } RoundTo((y1 * Matrix[5]) { +(z*matrix[9]) } + (1 * Matrix[13]), -4);                // ������� �������������� 1
              PointsArray[Strk - 3, 3] := { (x*matrix[2])+(y*matrix[6])+ } RoundTo((z1 * Matrix[10]) + (1 * Matrix[14]), -4);          // ������� �������������� 1

              PointsArray[Strk - 2, 1] :=RoundTo((x2 * Matrix[0]) { +(y*matrix[4])+(z*matrix[8]) } + (1 * Matrix[12]), -4); // ������� �������������� 2
              PointsArray[Strk - 2, 2] := { (x*matrix[1])+ } RoundTo((y2 * Matrix[5]) { +(z*matrix[9]) } + (1 * Matrix[13]), -4);               // ������� �������������� 2
              PointsArray[Strk - 2, 3] :={ (x*matrix[2])+(y*matrix[6])+ } RoundTo((z2 * Matrix[10]) + (1 * Matrix[14]), -4);          // ������� �������������� 2

              PointsArray[Strk - 1, 1] :=RoundTo((x3 * Matrix[0]) { +(y*matrix[4])+(z*matrix[8]) } +(1 * Matrix[12]), -4); // ������� �������������� 3
              PointsArray[Strk - 1, 2] := { (x*matrix[1])+ } RoundTo((y3 * Matrix[5]) { +(z*matrix[9]) } + (1 * Matrix[13]), -4);                // ������� �������������� 3
              PointsArray[Strk - 1, 3] := { (x*matrix[2])+(y*matrix[6])+ } RoundTo((z3 * Matrix[10]) + (1 * Matrix[14]), -4);     // ������� �������������� 3
              // ------------------------------�������--------------------------------
              e1x := PointsArray[Strk - 2, 1] - PointsArray[Strk - 3, 1];
              e1y := PointsArray[Strk - 2, 2] - PointsArray[Strk - 3, 2];
              e1z := PointsArray[Strk - 2, 3] - PointsArray[Strk - 3, 3];

              e2x := PointsArray[Strk - 1, 1] - PointsArray[Strk - 3, 1];
              e2y := PointsArray[Strk - 1, 2] - PointsArray[Strk - 3, 2];
              e2z := PointsArray[Strk - 1, 3] - PointsArray[Strk - 3, 3];

              PointsArray[Strk - 3, 8] := (e1y * e2z) - (e1z * e2y);

              PointsArray[Strk - 3, 9] := (e1z * e2x) - (e1x * e2z);

              PointsArray[Strk - 3, 10] := (e1x * e2y) - (e1y * e2x);

              PointsArray[Strk - 3, 11] :=
                (PointsArray[Strk - 3, 8] * PointsArray[Strk - 3, 1]) +
                (PointsArray[Strk - 3, 9] * PointsArray[Strk - 3, 2]) +
                (PointsArray[Strk - 3, 10] * PointsArray[Strk - 3, 3]);
              // ------------------------------�������--------------------------------
              PointsArray[Strk - 3, 5] := (ColorParam.specularity);
              PointsArray[Strk - 3, 6] := (ColorParam.diffuse);
              PointsArray[Strk - 3, 7] := (ColorParam.transparency);

              PointsArray[Strk - 3, 4] := 1;

              Strk := Strk + 3; // ���������� ����� � �������
            end
            else
            begin
              exit;
            end;
          end
          else
          begin
            showmessage('���������������� �������� ����� ������ 3 ������');
            exit;
          end;
        gauge2.Progress:=j;
        end;
      Gauge1.Progress := n_gran_t;
      inc(n_gran_t);
      end;
    end;
  end;

  Strk := Strk - 3;
  SetLength(PointsArray, Strk, 15);

end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
var
  index, i, j, k: Integer;
begin
  Strk_ALL := 1;
  SetLength(Points_ALL, Strk + Strk2 + Strk_p + 1, 15);
  for i := 0 to Strk - 1 do
  begin
    Points_ALL[Strk_ALL - 1, 1] := PointsArray[i, 1];
    Points_ALL[Strk_ALL - 1, 2] := PointsArray[i, 2];
    Points_ALL[Strk_ALL - 1, 3] := PointsArray[i, 3];
    Points_ALL[Strk_ALL - 1, 4] := PointsArray[i, 4];
    Points_ALL[Strk_ALL - 1, 5] := PointsArray[i, 5];
    Points_ALL[Strk_ALL - 1, 6] := PointsArray[i, 6];
    Points_ALL[Strk_ALL - 1, 7] := PointsArray[i, 7];
    Points_ALL[Strk_ALL - 1, 8] := 0;
    Points_ALL[Strk_ALL - 1, 8] := PointsArray[i, 8];
    Points_ALL[Strk_ALL - 1, 9] := PointsArray[i, 9];
    Points_ALL[Strk_ALL - 1, 10] := PointsArray[i, 10];
    Points_ALL[Strk_ALL - 1, 11] := PointsArray[i, 11];
    Points_ALL[Strk_ALL - 1, 12] := 0;

    inc(Strk_ALL);
    // SetLength(Points_ALL, Strk_ALL, 15);
  end;

  if PointsArray2 = nil then
  begin
  end
  else
  begin
    for j := 0 to Strk2 - 4 do
    begin
      Points_ALL[Strk_ALL - 1, 1] := PointsArray2[j, 1];
      Points_ALL[Strk_ALL - 1, 2] := PointsArray2[j, 2];
      Points_ALL[Strk_ALL - 1, 3] := PointsArray2[j, 3];
      Points_ALL[Strk_ALL - 1, 4] := PointsArray2[j, 4];
      Points_ALL[Strk_ALL - 1, 5] := PointsArray2[j, 5];
      Points_ALL[Strk_ALL - 1, 6] := PointsArray2[j, 6];
      Points_ALL[Strk_ALL - 1, 7] := PointsArray2[j, 7];
      Points_ALL[Strk_ALL - 1, 8] := 0;
      Points_ALL[Strk_ALL - 1, 8] := PointsArray2[j, 8];
      Points_ALL[Strk_ALL - 1, 9] := PointsArray2[j, 9];
      Points_ALL[Strk_ALL - 1, 10] := PointsArray2[j, 10];
      Points_ALL[Strk_ALL - 1, 11] := PointsArray2[j, 11];
      Points_ALL[Strk_ALL - 1, 12] := 0;

      inc(Strk_ALL);
      // SetLength(Points_ALL, Strk_ALL, 15);
    end;
  end;

  if Plosk_Array = nil then
  begin
  end
  else
  begin
    for k := 0 to Strk_p - 4 do
    begin
      Points_ALL[Strk_ALL - 1, 1] := Plosk_Array[k, 1];
      Points_ALL[Strk_ALL - 1, 2] := Plosk_Array[k, 2];
      Points_ALL[Strk_ALL - 1, 3] := Plosk_Array[k, 3];
      Points_ALL[Strk_ALL - 1, 4] := Plosk_Array[k, 4];
      Points_ALL[Strk_ALL - 1, 8] := Plosk_Array[k, 8];
      Points_ALL[Strk_ALL - 1, 5] := Plosk_Array[k, 5];
      Points_ALL[Strk_ALL - 1, 6] := Plosk_Array[k, 6];
      Points_ALL[Strk_ALL - 1, 7] := Plosk_Array[k, 7];
      Points_ALL[Strk_ALL - 1, 8] := Plosk_Array[k, 8];
      Points_ALL[Strk_ALL - 1, 9] := Plosk_Array[k, 9];
      Points_ALL[Strk_ALL - 1, 10] := Plosk_Array[k, 10];
      Points_ALL[Strk_ALL - 1, 11] := Plosk_Array[k, 11];
      Points_ALL[Strk_ALL - 1, 12] := Plosk_Array[k, 12];

      inc(Strk_ALL);
      // SetLength(Points_ALL, Strk_ALL, 15);
    end;
  end;

  dec(Strk_ALL);
  SetLength(Points_ALL, Strk_ALL, 15);
  // form1.FormStyle:=fsStayOnTop;
  form1.Frame21.Render;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Form3.Caption := '������������ ����������';
  Label2.Caption := '�������� ������������ � ���������' + #10#13 +
                    '�� 1 �� 100 ��� 1 - ��� ���-' + #10#13 +
                    '��������� ��������, �������������' + #10#13 + '�������� 25-50';
  Memo1.Clear;
  abort_loop := true;
end;

end.
