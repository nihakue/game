arenaSize = 300
dcount = 0
maxBullets = 5

lockSize = 10
lockSpeed = 30
spellRange = 1.5

 
--ucount = 0 

bullets = {}
--[[
for i = 1 , 100 do
	proj[i] = {}
end
--]]
bulletsOnScreen = 0

function addbullet( x , y , dx , dy)
	blt = {}
	blt.range = spellRange
	blt.distanceTraveled = 0
	mag = math.sqrt((dx - lock.body:getX())^2 + (dy - lock.body:getY())^2)
	
	nx = (dx - lock.body:getX()) / mag
	ny = (dy - lock.body:getY()) / mag
	
	blt.body = love.physics.newBody( world, x + (nx*8) , y + (ny*8) , "dynamic")
	blt.shape = love.physics.newCircleShape( 3 )
	blt.fixture = love.physics.newFixture( blt.body, blt.shape)
	blt.body:setLinearVelocity( nx*200, ny*200 ) 
	bulletsOnScreen = bulletsOnScreen + 1 
	table.insert(bullets, blt)
	if bulletsOnScreen == maxBullets then
		table.remove(bullets, 1)
		bulletsOnScreen = bulletsOnScreen - 1
		
	end
	
	
end
	
	
	
function drawBullets()
	love.graphics.setColor( 0 , 0 , 0 ) 
	
	for i, v in ipairs(bullets) do
		love.graphics.circle ( "fill" , v.body:getX() , v.body:getY() , 3) 
	end
end



function love.load()
	lock = {}
	world = love.physics.newWorld ( 0 , 0 ) 
	
	lock.body = love.physics.newBody( world , 200 , 200 , "dynamic")
	lock.shape =  love.physics.newCircleShape( lockSize )
	lock.fixture = love.physics.newFixture( lock.body , lock.shape ) 
	
	lock.body:setLinearDamping( 2 ) 
	
	createPillars()
	
	
	
	print( lock )
	
end


function love.draw()
	love.graphics.setBackgroundColor( 255 , 50 , 25)
	drawArena()
	drawLock()
	drawPillars()
	drawBullets()	
		
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
	
	
	for i,v in ipairs(bullets) do
		v.distanceTraveled = v.distanceTraveled + dt
		if v.distanceTraveled > v.range then
			table.remove(bullets, i)
			bulletsOnScreen = bulletsOnScreen -1
		end
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

function createPillars()
	pillar = {}
	
	pillar.body = love.physics.newBody( world , 300 , 350, "static")
	pillar.shape =  love.physics.newCircleShape( 20 )
	pillar.fixture = love.physics.newFixture(pillar.body , pillar.shape) 
end

function drawPillars()
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", pillar.body:getX(), pillar.body:getY(), pillar.shape:getRadius())
end
	
	
	
	
	