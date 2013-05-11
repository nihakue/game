arenaSize = 300
dcount = 0

lockSize = 10
lockSpeed = 30

 
--ucount = 0 

proj = {}
for i = 1 , 100 do
	proj[i] = {}
end
projtop = 0

function addbullet( x , y , dx , dy)
	blt = {}
	mag = math.sqrt((dx - lock.body:getX())^2 + (dy - lock.body:getY())^2)
	
	nx = (dx - lock.body:getX()) / mag
	ny = (dy - lock.body:getY()) / mag
	
	blt.body = love.physics.newBody( world, x + (nx*8) , y + (ny*8) , "dynamic")
	blt.shape = love.physics.newCircleShape( 3 )
	blt.fixture = love.physics.newFixture( blt.body, blt.shape)
	blt.body:setLinearVelocity( nx*200, ny*200 ) 
	projtop = projtop + 1 
	proj[projtop] = blt
end
	
	
	
function drawproj()
	love.graphics.setColor( 0 , 0 , 0 ) 
	
	for i = 1 , projtop do
		love.graphics.circle ( "fill" , proj[i].body:getX() , proj[i].body:getY() , 3) 
	end
end



function love.load()
	lock = {}
	world = love.physics.newWorld ( 0 , 0 ) 
	
	lock.body = love.physics.newBody( world , 200 , 200 , "dynamic")
	lock.shape =  love.physics.newCircleShape( lockSize )
	lock.fixture = love.physics.newFixture( lock.body , lock.shape ) 
	
	lock.body:setLinearDamping( 2 ) 
	
	
	print( lock )
	
end


function love.draw()
	love.graphics.setBackgroundColor( 255 , 50 , 25)
	drawArena()
	drawLock()
	drawproj()		
		
	dcount = dcount + 1
	
	if dcount % 100 == 0 then
		arenaSize = arenaSize - 1 
	end
	
	love.graphics.print( dcount , 0 , 0 )
	
	
--	love.graphics.print( ucount , 0 , 10)	
	
end


function love.update(dt)
	--ucount = ucount + 1
	
	if love.keyboard.isDown( "w" ) then
		lock.body:applyForce( 0 , -lockSpeed)
	end
	if love.keyboard.isDown( "a" ) then
		lock.body:applyForce( -lockSpeed , 0)
	end
	if love.keyboard.isDown( "d" ) then
		lock.body:applyForce( lockSpeed , 0)
	end
	if love.keyboard.isDown( "s" ) then
		lock.body:applyForce( 0 , lockSpeed) 
	end
	

	
	
	world:update(dt) 
end


function love.mousepressed ( x , y , button) 
	addbullet( lock.body:getX() , lock.body:getY() , x , y ) 
end

function drawArena() 
	love.graphics.setColor( 0 , 153 , 204 ) 
	love.graphics.circle("fill", 400 , 300 , arenaSize)
end



function drawLock()
	love.graphics.setColor( 200 , 200 , 200) 
	love.graphics.circle ( "fill" , lock.body:getX() , lock.body:getY() , lockSize ) 
end

