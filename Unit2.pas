unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dglOpenGL, Vcl.AppEvnts,
  Vcl.StdCtrls, math;

type
  TFrame2 = class(TFrame)
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    btUp: TButton;
    btLeft: TButton;
    btRight: TButton;
    btDown: TButton;
    btDefault: TButton;
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FrameDblClick(Sender: TObject);
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FrameMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure btLeftClick(Sender: TObject);
    procedure btRightClick(Sender: TObject);
    procedure btDefaultClick(Sender: TObject);
  private
    angX, angY, m: GLfloat; // mouse
    lastx, lasty: Integer; // mouse
    AngX1, AngY1, AngZ1, AngX2, AngY2, AngZ2: GLfloat;
    Flag_Pl, Flag_Lu, Flag_All_Lu: Boolean;
    { Private declarations }
  protected
    class var FPixelFormat: Integer;

  var
    FDC: HDC;
    FRC: HGLRC;
    class constructor Create;
    procedure SetDCPixelFormat;
    procedure SetupRC;
  public
   Flag_Kont     : boolean;
   Flag_Lu_St    : boolean;
   Flag_Lu_End   : boolean;
   Flag_Lu_End_0 : boolean;
   Flag_Lu_End_1 : boolean;
   Flag_Lu_End_2 : boolean;
   Flag_Lu_End_3 : boolean;
   Flag_Lu_End_All: boolean;
   Flag_Fotom    : boolean;
   Flag_Body     : boolean;
   Flag_Plos     : boolean;
    procedure OnCreate(var msg: TMessage); message WM_CREATE;
    procedure OnDestroy(var msg: TMessage); message WM_DESTROY;
    procedure OnPaint(var msg: TWMPaint); message WM_PAINT;
    procedure OnEraseBackground(var msg: TMessage); message WM_ERASEBKGND;
    procedure OnSize(var msg: TMessage); message WM_SIZE;
    procedure Render;


    { Public declarations }
  end;

var
  Down: Boolean = False; // ��� ����
  Flag_Render: Integer;
implementation

uses Unit1;
{$R *.dfm}

procedure TFrame2.AppEventsIdle(Sender: TObject; var Done: Boolean);
begin
  Render;
  Done := False;
end;

procedure TFrame2.Button1Click(Sender: TObject);
begin
m:=1;
Render;
end;

procedure TFrame2.Button2Click(Sender: TObject);
begin
  m:=m-0.2;
Render;
end;

procedure TFrame2.Button3Click(Sender: TObject);
begin
      m:=m+0.2;
Render;
end;



procedure TFrame2.btDefaultClick(Sender: TObject);
begin
glPopMatrix();
 InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.btDownClick(Sender: TObject);
begin
glRotatef(-1, 0, 0 , 1);
InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.btLeftClick(Sender: TObject);
begin
glRotatef(1, 0, 1 , 0);
InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.btRightClick(Sender: TObject);
begin
  glRotatef(-1, 0, 1 , 0);
  InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.btUpClick(Sender: TObject);
begin
//gluLookAt(0, 0, 10, 0, 0, 0, 0,0,10);
glRotatef(1, 0, 0, 1);
InvalidateRect(Handle, nil, False);
end;



class constructor TFrame2.Create;
begin
  FPixelFormat := 0;
  InitOpenGL;
end;

procedure TFrame2.FrameDblClick(Sender: TObject);
begin
  AngX2 := 0.0;
  AngY1 := 0.0;
  AngX1 := 0;
  AngY2 := 0.0;

  glViewport(0, 0, ClientWidth, ClientHeight);
  glLoadIdentity;
  InvalidateRect(Handle, nil, False);
  m := 1;
  // formresize(nil);
end;

procedure TFrame2.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lastx := X;
  lasty := Y;
  Down := True;
end;

procedure TFrame2.FrameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If Down then
  begin
    glRotatef(lastx - X, 0.0, 1.0, 0.0);
    glRotatef(lasty - Y, 1.0, 0.0, 0.0);
    lastx := X;
    lasty := Y;
    InvalidateRect(Handle, nil, False);
    caption := 'x= ' + inttostr(lastx) + ' y= ' + inttostr(lasty);
  end;
end;

procedure TFrame2.FrameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Down := False;
end;

procedure TFrame2.FrameMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  m := m - 0.1;
  InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.FrameMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  m := m + 0.1;
  InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.OnCreate(var msg: TMessage);
begin
  inherited;
  FDC := GetDC(Handle);
  SetDCPixelFormat;
  FRC := wglCreateContext(FDC);
  ActivateRenderingContext(FDC, FRC);
  SetupRC;
  m := 1;
Flag_Kont      := TRUE;
Flag_Lu_St     := TRUE;
Flag_Lu_End    := TRUE;
 Flag_Lu_End_0 := TRUE;
 Flag_Lu_End_1 := TRUE;
 Flag_Lu_End_2 := TRUE;
 Flag_Lu_End_3 := TRUE;
 Flag_Lu_End_All:= TRUE;
Flag_Fotom     := TRUE;
Flag_Body      := TRUE;
Flag_Plos      := TRUE;
end;

procedure TFrame2.OnDestroy(var msg: TMessage);
begin
  wglMakeCurrent(0, 0);
  wglDeleteContext(FRC);
  ReleaseDC(Handle, FDC);
  inherited;
end;

procedure TFrame2.SetDCPixelFormat;
var
  pfd: TPixelFormatDescriptor;
begin
  if FPixelFormat = 0 then
  begin
    FillChar(pfd, SizeOf(pfd), 0);
    pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_DOUBLEBUFFER or PFD_SUPPORT_OPENGL;
    pfd.cDepthBits := 32;
    pfd.cColorBits := 32;
    FPixelFormat := ChoosePixelFormat(FDC, @pfd);
  end;
  SetPixelFormat(FDC, FPixelFormat, @pfd);
end;

procedure TFrame2.OnSize(var msg: TMessage);
begin
  // ����� ��������� �������� � ������
  glViewport(0, 0, LOWORD(msg.LParam), HIWORD(msg.LParam));
  // ������ �� ��������
  // glViewport(0, 0, ClientWidth, ClientHeight);
  glMatrixMode(GL_PROJECTION);

  // gluPerspective( 45, LOWORD(msg.LParam)/HIWORD(msg.LParam), 1, 2.0 );

  // glOrtho(0, 200.0, 310.0, 510.0, 0.0, 100.0);

  glMatrixMode(GL_MODELVIEW);
  // ������ �� ��������
  // glViewport(0, 0, ClientWidth, ClientHeight);

  // glMatrixMode(GL_PROJECTION);
  // glLoadIdentity();
  // glOrtho(0, 2.0, 3.0, 5.0, 0.0, 1.0);

  glLoadIdentity;
  InvalidateRect(Handle, nil, False);
end;

procedure TFrame2.OnPaint(var msg: TWMPaint);
var
  ps: TPaintStruct;
begin
  BeginPaint(Handle, ps);
  Render;
  EndPaint(Handle, ps);
end;

procedure TFrame2.OnEraseBackground(var msg: TMessage);
begin
  msg.Result := 1;
end;

procedure TFrame2.SetupRC;
begin
  // ���������
  glClearColor(0.85, 0.85, 0.85, 1.0);
  glEnable(GL_DEPTH_TEST);
  // glEnable( GL_LIGHTING );
  // glEnable( GL_LIGHT0 );
  // glEnable( GL_COLOR_MATERIAL );
  // glColorMaterial( GL_FRONT, GL_AMBIENT_AND_DIFFUSE );
end;

procedure TFrame2.Render;
var
  i, j, p, p1, i1, k, k1, k2, k3, R, k21, n_shag, n_col: Integer;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glPushMatrix;
  glScaled(m, m, m);
  form1.caption := ('�������= '+ floattostr(Roundto(m, -4)));


  if Flag_Kont then
  begin
        if CheckBox1.Checked then
        begin
          // ���� ������� �� �������� ���������
          glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        end
        else
        begin
               glEnable(GL_ALPHA_TEST);

              glEnable(GL_BLEND);

              glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

         if Points_ALL <> nil then
          begin
            i := 0;
            for j := 0 to ((Strk_ALL) div 3) - 1 do
            begin
              if Points_ALL[i, 4] = 1 then
              begin
              glLineWidth(2);
                case Flag_Render of
                  1: glBegin(GL_lines);
                  2: glBegin(GL_line_loop);
                else
                  glBegin(GL_lines);
                end;
                glColor4d(0.0, 0.0, 0.0, 1);
                glVertex3f(Points_ALL[i, 1] / (100), Points_ALL[i, 2] / (100), Points_ALL[i, 3] / (100));
                glVertex3f(Points_ALL[i + 1, 1] / (100), Points_ALL[i + 1, 2] / (100), Points_ALL[i + 1, 3] / (100));
                glVertex3f(Points_ALL[i + 2, 1] / (100), Points_ALL[i + 2, 2] / (100), Points_ALL[i + 2, 3] / (100));
                glEnd;
                i := i + 3;
                if i >= Strk_ALL then
                begin
                  break;
                end;
              end;
              if Points_ALL[i, 4] = 2 then
              begin
             glLineWidth(2);
                case Flag_Render of
                  1: glBegin(GL_lines);
                  2: glBegin(GL_line_loop);
                else
                  glBegin(GL_lines);
                end;
                glColor4d(0.0, 0.0, 0.0, 1);
                glVertex3f(Points_ALL[i, 1] / (100), Points_ALL[i, 2] / (100), Points_ALL[i, 3] / (100));
                glVertex3f(Points_ALL[i + 1, 1] / (100), Points_ALL[i + 1, 2] / (100), Points_ALL[i + 1, 3] / (100));
                glVertex3f(Points_ALL[i + 2, 1] / (100), Points_ALL[i + 2, 2] / (100), Points_ALL[i + 2, 3] / (100));
                glEnd;
                i := i + 3;
                if i >= Strk_ALL then
                begin
                  break;
                end;
              end;
              if (Points_ALL[i, 4] = 3) then
              begin
                i := i + 3;
                if i >= Strk_ALL then
                begin
                  break;
                end;
              end;
            end;
          end;
        end;

  end;






  if Flag_Lu_St then
  begin
        if Flag_Lu then
        begin
          if Light_Array <> nil then
          begin
            for k := 0 to Strk_L - 1 do
            begin
              glBegin(GL_lines);
              glColor3f(1.0, 0.0, 0.0);
              glVertex3f(Light_Array[k, 1] / 100, Light_Array[k, 2] / 100, Light_Array[k, 3] / 100);
              glVertex3f(Light_Array[k, 4] / 100, Light_Array[k, 5] / 100, Light_Array[k, 6] / 100);
              glEnd;

              glPointSize(4.5);
              glBegin(GL_points);
              glColor3f(1.0, 1.0, 0.0);
              glVertex3f(Light_Array[k, 4] / 100, Light_Array[k, 5] / 100, Light_Array[k, 6] / 100);
              glEnd;
            end;

          end
          else
          begin
          end;
          form1.caption := inttostr(k);
        end;

  end;







  if Flag_Lu_End then
  begin
  k1:=0;
  n_col := ceil(Strk_End * (strtofloat(form1.edit4.Text)/100));
  n_shag :=  ceil(Strk_End / n_col) ;

              if Array_Trass_End <> nil then
              begin
               for k21 := 0 to n_col -1 do
               begin

                if Flag_Lu_End_All then
                begin
                  if Array_Trass_End[k1, 7] = 1 then
                  begin
                    glColor4d(1.0, 0.0, 0.0, 0.95);
                  end
                  else if Array_Trass_End[k1, 7] = 2 then
                  begin
                    glColor4d(1.0, 0.0, 1.0, 0.95);
                    glBegin(GL_lines);
                    glEnd;
                  end
                  else
                  begin
                    glColor4d(0.0, 0.0, 1.0, 0.95);
                    glBegin(GL_lines);
                    glEnd;
                  end;

                    if Array_Trass_End[k1, 9] = 0 then
                    begin
                      glBegin(GL_lines);
                      glVertex3f(Array_Trass_End[k1, 1] / 100, Array_Trass_End[k1, 2] / 100, Array_Trass_End[k1, 3] / 100);
                      glVertex3f(Array_Trass_End[k1, 4] / 100, Array_Trass_End[k1, 5] / 100, Array_Trass_End[k1, 6] / 100);
                      glEnd;
                    end;
                end;

                if Flag_Lu_End_0 then
                begin
                  if Array_Trass_End[k1, 7] = 1 then
                  begin
                  glColor4d(1.0, 0.0, 0.0, 0.95);
                  glBegin(GL_lines);
                    glVertex3f(Array_Trass_End[k1, 1] / 100, Array_Trass_End[k1, 2] / 100, Array_Trass_End[k1, 3] / 100);
                    glVertex3f(Array_Trass_End[k1, 4] / 100, Array_Trass_End[k1, 5] / 100, Array_Trass_End[k1, 6] / 100);
                  glEnd;
                  end;
                end;

                if Flag_Lu_End_1 then
                begin
                  if Array_Trass_End[k1, 7] = 2 then
                  begin
                  glColor4d(1.0, 0.0, 1.0, 0.95);
                  glBegin(GL_lines);
                    glVertex3f(Array_Trass_End[k1, 1] / 100, Array_Trass_End[k1, 2] / 100, Array_Trass_End[k1, 3] / 100);
                    glVertex3f(Array_Trass_End[k1, 4] / 100, Array_Trass_End[k1, 5] / 100, Array_Trass_End[k1, 6] / 100);
                  glEnd;
                  end;

                end;

                if Flag_Lu_End_2 then
                begin
                  if Array_Trass_End[k1, 7] = 3 then
                  begin
                  glColor4d(0.0, 0.0, 1.0, 0.95);
                  glBegin(GL_lines);
                    glVertex3f(Array_Trass_End[k1, 1] / 100, Array_Trass_End[k1, 2] / 100, Array_Trass_End[k1, 3] / 100);
                    glVertex3f(Array_Trass_End[k1, 4] / 100, Array_Trass_End[k1, 5] / 100, Array_Trass_End[k1, 6] / 100);
                  glEnd;
                  end;
                end;

                if Flag_Lu_End_3 then
                begin
                  if Array_Trass_End[k1, 7] = 4 then
                  begin
                  glColor4d(0.0, 1.0, 1.0, 0.95);
                  glBegin(GL_lines);
                    glVertex3f(Array_Trass_End[k1, 1] / 100, Array_Trass_End[k1, 2] / 100, Array_Trass_End[k1, 3] / 100);
                    glVertex3f(Array_Trass_End[k1, 4] / 100, Array_Trass_End[k1, 5] / 100, Array_Trass_End[k1, 6] / 100);
                  glEnd;
                  end;
                end;

               k1:=k1+n_shag;
               end;


              end;





  end;







  if Flag_Fotom then
  begin
                 if Array_Fotom_End_20 <> nil then
                 begin
                 R:=0;
                   for k3 := 0 to (RaTaTa_20 div 2)-1 do
                    begin
                    glLineWidth(3);
                      glBegin(GL_lines);
                      glColor3f (1.0, 0.79, 0.0);
                        glVertex3f(Array_Fotom_End_20[R, 1] * form1.Mnoj_Fotom, Array_Fotom_End_20[R, 2] * form1.Mnoj_Fotom, Array_Fotom_End_20[R, 3] * form1.Mnoj_Fotom);
                        glVertex3f(Array_Fotom_End_20[R+1, 1] * form1.Mnoj_Fotom, Array_Fotom_End_20[R+1, 2] * form1.Mnoj_Fotom, Array_Fotom_End_20[R+1, 3] * form1.Mnoj_Fotom);
                      glEnd;
                    R:=R+2;
                    end;
                 end;
  end;


  if Flag_Body then
  begin

              if Points_ALL <> nil then
              begin
                i := 0;
                for j := 0 to ((Strk_ALL) div 3) - 1 do
                begin
                  if Points_ALL[i, 4] = 1 then
                  begin
                  glLineWidth(1);
                    glBegin(GL_TRIANGLES);
                    glColor4d(0.2, 0.2, 0.2, 0.75);
                    glVertex3f(Points_ALL[i, 1] / (100), Points_ALL[i, 2] / (100), Points_ALL[i, 3] / (100));
                    glVertex3f(Points_ALL[i + 1, 1] / (100), Points_ALL[i + 1, 2] / (100), Points_ALL[i + 1, 3] / (100));
                    glVertex3f(Points_ALL[i + 2, 1] / (100), Points_ALL[i + 2, 2] / (100), Points_ALL[i + 2, 3] / (100));
                    glEnd;
                    i := i + 3;
                    if i >= Strk_ALL then
                    begin
                      break;
                    end;
                  end;
                  if Points_ALL[i, 4] = 2 then
                  begin
                  glLineWidth(1);
                    glBegin(GL_TRIANGLES);
                    glColor4d(0.0, 1.0, 0.0, 0.9);
                    glVertex3f(Points_ALL[i, 1] / (100), Points_ALL[i, 2] / (100), Points_ALL[i, 3] / (100));
                    glVertex3f(Points_ALL[i + 1, 1] / (100), Points_ALL[i + 1, 2] / (100), Points_ALL[i + 1, 3] / (100));
                    glVertex3f(Points_ALL[i + 2, 1] / (100), Points_ALL[i + 2, 2] / (100), Points_ALL[i + 2, 3] / (100));
                    glEnd;
                    i := i + 3;
                    if i >= Strk_ALL then
                    begin
                      break;
                    end;
                  end;
                  if Points_ALL[i, 4] = 3 then
                  begin
                    i := i + 3;
                    if i >= Strk_ALL then
                    begin
                      break;
                    end;
                  end;
                end;
              end;
  end;


  if Flag_Plos then
  begin

          if Plosk_Array <> nil then
          begin
                R:=0;
                for k3 := 0 to (Strk_P div 4)-1 do
                    begin
                    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
                      glBegin(GL_QUADS);
                      glColor4d (1.0, 0.85, 0.2, 0.7);
                        glVertex3f(Plosk_Array[R, 1]/100,   Plosk_Array[R, 2]/100,   Plosk_Array[R, 3]/100);
                        glVertex3f(Plosk_Array[R+1, 1]/100, Plosk_Array[R+1, 2]/100, Plosk_Array[R+1, 3]/100);
                        glVertex3f(Plosk_Array[R+2, 1]/100, Plosk_Array[R+2, 2]/100, Plosk_Array[R+2, 3]/100);
                        glVertex3f(Plosk_Array[R+3, 1]/100, Plosk_Array[R+3, 2]/100, Plosk_Array[R+3, 3]/100);
                      glEnd;
                    R:=R+4;
                    end;



               R:=0;
                for k3 := 0 to (Strk_P div 4)-1 do
                    begin
                    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
                    glLineWidth(1.5);
                      glBegin(GL_POLYGON);
                      glColor4d (0.0, 0.0, 0.0, 0.9);
                        glVertex3f(Plosk_Array[R, 1]/100,   Plosk_Array[R, 2]/100,   Plosk_Array[R, 3]/100);
                        glVertex3f(Plosk_Array[R+1, 1]/100, Plosk_Array[R+1, 2]/100, Plosk_Array[R+1, 3]/100);
                        glVertex3f(Plosk_Array[R+2, 1]/100, Plosk_Array[R+2, 2]/100, Plosk_Array[R+2, 3]/100);
                        glVertex3f(Plosk_Array[R+3, 1]/100, Plosk_Array[R+3, 2]/100, Plosk_Array[R+3, 3]/100);
                      glEnd;
                    R:=R+4;
                    end;
          end;

  end;


  if CheckBox1.Checked <> True then
  begin
    glDisable(GL_BLEND);
    glDisable(GL_ALPHA_TEST);
  end;

  glPopMatrix;
  SwapBuffers(FDC);
end;

end.
