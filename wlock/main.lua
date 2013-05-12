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
	blt.fixture:setUserData('bullet')
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
	world:setCallbacks(beginContact)	
	lock.body = love.physics.newBody( world , 200 , 200 , "dynamic")
	lock.shape =  love.physics.newCircleShape( lockSize )
	lock.fixture = love.physics.newFixture( lock.body , lock.shape ) 
	lock.fixture:setUserData('lock')	
	lock.body:setLinearDamping( 2 ) 
	
	createPillars()
	debugText = ""
	
	
	print( lock )
	
end

function beginContact(a, b, coll)
	x,y = coll:getNormal()
	aUD = a:getUserData()
	bUD = b:getUserData()
	debugText = "collision at x: "..x.." y: "..y.." between a: "..a:getUserData().." and b: "..b:getUserData()
	if aUD == 'bullet' or bUD == 'bullet' then
		if aUD == 'pillar' or bUD == 'pillar' then
				anim_explodeBullet(a)	
				table.remove(bullets, 1)
				bulletsOnScreen = bulletsOnScreen -1	
		end
	end
end
--This is a test animation for exploding bullets
function anim_explodeBullet(bullet)
--I have to do this because I can only pass a fixture. there's probably a better way to do this
	debugText = bullet:type()
	bShape = bullet:getShape()
	bBody = bullet:getBody()

	explodeSpeed = 10
	maxSize = 1000
	x, y = bBody:getX(), bBody:getY()
	r = bShape:getRadius()
	repeat
		--print("x: "..x.." y: "..y.." radius: "..r)
		love.graphics.circle("fill", x, y, r)
		r = r + explodeSpeed
	until r > maxSize
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
	love.graphics.print( debugText, 10, 10)
	love.graphics.print("Current FPS: "..love.timer.getFPS(), 10, 20)
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
--We set the userdata for collision resolution.
	pillar.fixture:setUserData('pillar')
end

function drawPillars()
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", pillar.body:getX(), pillar.body:getY(), pillar.shape:getRadius())
end
	
		
	
	
	
