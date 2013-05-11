function love.load()
	elapsed=0
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	objects = {}
	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2)
	objects.ground.shape = love.physics.newRectangleShape(650, 50)
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
--let's create the ball
	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(20)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
	objects.ball.fixture:setRestitution(0.5)
	objects.ball.body:setLinearDamping(2.0)	

--let's create a couple of blocks to play around with

	objects.block1 = {}
	objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
	objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
	objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5)

	objects.block2 = {}
	objects.block2.body = love.physics.newBody(world, 200, 550, "dynamic")
	objects.block2.shape = love.physics.newRectangleShape(0, 0, 200, 100)
	objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 5)
	
	love.graphics.setBackgroundColor(104, 136, 248)
	love.graphics.setMode(650, 650, false, true, 0)
end


function love.update(dt)
	elapsed = elapsed + dt
	world:update(dt)
	if love.keyboard.isDown("left") then
		objects.ball.body:applyForce(-400, 0)
	end
	if love.keyboard.isDown("right") then
		objects.ball.body:applyForce(400, 0)
	end
	if love.keyboard.isDown("up") then
		objects.ball.body:applyForce(0, -400)
	end
	if love.keyboard.isDown("down") then
		objects.ball.body:applyForce(0, 400)
	end

end

function love.keypressed(key, unicode)
	print(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	love.graphics.setColor(76,160,14)
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	
	love.graphics.setColor(50, 50, 50)
	love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))

	love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
end

