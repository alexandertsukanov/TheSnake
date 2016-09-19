uses
  GraphABC;

type
  Cell =
  record
    x: integer;
    y: integer;
  end;


var
  rabbit: Cell;
  snake: array of Cell;
  walls: array of Cell;
  dir_x: integer;
  dir_y: integer;
  drive: integer := 180;
  Game: boolean := true;

label 1, 2;

const
  W: integer = 600;//Ўирина
  H: integer = 400;//высота
  CS: integer = 20;//размер €чейки
  FW: integer = W div CS;//кол-во €чеек по ширине
  FH: integer = H div CS;// кол-во €чеек по высоте


procedure drawSnake();
begin
  
  SetPenColor(RGB($66, $66, $88));
  SetBrushColor(ARGB(128, $FF, 0, 0));
  
  
  for var i: integer := Length(snake) - 1 downto 0 do
  begin
    if (i = 0) then 
      SetBrushColor(RGB(0, $AA, $CC))
    else 
      SetBrushColor(RGB($FF, 0, 0));
    
    rectangle(snake[i].x * CS, snake[i].y * CS, snake[i].x * CS + CS, snake[i].y * CS + CS);
  end;
  
end;

procedure drawGrid();

begin
  setPenColor(RGB($CC, $CC, $CC));
  for var i: integer := 0 to FW do 
    Line(i * CS, 0, i * CS, H);
  for var i: integer := 0 to FH do
    Line(0, i * CS, W, i * CS);
end;


procedure Onkey(key: integer);

begin
  
  
  case key of 
    
    VK_Up: 
      begin
        dir_x := 0;
        dir_y := -1;
      end;
    VK_Down:
      begin
        dir_x := 0;
        dir_y := 1;
      end;
    VK_Left:
      begin
        dir_x := -1;
        dir_y := 0;
      end;
    VK_Right:
      begin
        dir_x := 1;
        dir_y := 0;
      end;
  
  end;
  
  
end;

procedure createWalls();
begin
for var i: integer := 0 to 20 do
 begin
    var w_cell: Cell;
    w_cell.y := random(0, FW - 1);
    w_cell.x := random(0, FH - 1);
    setLength(walls, (i + 1));
    walls[i] := w_cell;   
  end;
end;

procedure drawWalls();
begin
for var i: integer := Length(walls) -1 downto 0 do
  begin
    SetBrushColor(RGB(0, 0, 0));
    rectangle(walls[i].x * CS, walls[i].y * CS, walls[i].x * CS + CS, walls[i].y * CS + CS);
  end;
end;

procedure createRabbit();
begin
  
  rabbit.x := random(0, FW - 1);
  rabbit.y := random(0, FH - 1);
end;

procedure drawRabbit();
begin
  SetBrushColor(RGB($FF, $FF, 0));
  rectangle(rabbit.x * CS, rabbit.y * CS, rabbit.x * CS + CS, rabbit.y * CS + CS);
end;

procedure moveSnake();

begin
  var head: Cell := snake[0];
  if(dir_x <> 0) or (dir_y <> 0) then 
  begin
    
    if(head.x + dir_x < 0) then
      head.x := FW
    else if (head.x + dir_x > FW - 1) then
      head.x := 0
    else 
      head.x := head.x + dir_x;
    
    if(head.y + dir_y < 0) then
      head.y := FH
    else if (head.y + dir_y > FH - 1) then
      head.y := 0
    else 
      head.y := head.y + dir_y;
    
  
    
    
    
    if head = rabbit then
    begin
      createRabbit();
      setLength(snake, Length(snake) + 1);
      drive := drive - 10;
      if(drive < 0) then
        drive := 0;
    end;
    
    var old_cell: Cell := snake[0];
    
    {for var i: integer := 0 to Length(snake) - 1  do
    begin
     var tmp: cell := snake[i];
     if head=snake[i] then game:=false;
    end;}
    
    for var i: integer := 0 to Length(snake) - 1 do 
    begin
      var tmp: cell := snake[i];
      snake[i] := old_cell;
      old_cell := tmp;
    end;
    
    snake[0] := head;
  end;
end;



begin
  createwalls();
  createRabbit();
  1:
  game := true;
  window.Width := W;
  window.Height := H;
  window.IsFixedSize := true;
  
  LockDrawing();
  OnkeyDown := OnKey;
  
  for var i: integer := 0 to 8 do
  begin
    var s_cell: Cell;
    s_cell.y := 10;
    s_cell.x := 10 - i;
    setLength(snake, (i + 1));
    snake[i] := s_cell;
    
  end;
  
  
  
  
  while game = true do
  begin
    
   
    
    window.Clear();
    
    drawGrid();
    
    
    
    drawWalls();
    
    drawRabbit();
    
    drawSnake();
    
    moveSnake();
    
    redraw();
    
    sleep(drive);
    
    if (game = false) then begin sleep(200);goto 1; end;
  end;
  
  
  
  
end.