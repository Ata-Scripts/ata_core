-- Execute a SQL query and return results
local function ExecuteSQL(query, params)
	if not query then return nil end
	
	local IsBusy = true
	local result = nil
	params = params or {}

	local function handleResult(data)
		result = data
		IsBusy = false
	end

	if Config.SQL == "oxmysql" then
		if MySQL == nil then
			exports.oxmysql:execute(query, params, handleResult)
		else
			MySQL.query(query, params, handleResult) 
		end
	elseif Config.SQL == "ghmattimysql" then
		exports.ghmattimysql:execute(query, params, handleResult)
	elseif Config.SQL == "mysql-async" then
		MySQL.Async.fetchAll(query, params, handleResult)
	end

	while IsBusy do
		Citizen.Wait(0)
	end
	return result
end

-- Insert a single row and return the inserted ID
local function InsertSQL(tableName, data)
	if type(tableName) ~= "string" or type(data) ~= "table" then
		return nil
	end

	local columns, values, params = {}, {}, {}
	
	for column, value in pairs(data) do
		if type(column) == "string" then
			table.insert(columns, column)
			table.insert(values, "?")
			table.insert(params, value)
		end
	end

	if #columns == 0 then return nil end

	local query = string.format(
		"INSERT INTO %s (%s) VALUES (%s)",
		tableName,
		table.concat(columns, ","),
		table.concat(values, ",")
	)

	return ExecuteSQL(query, params)
end

exports("InsertSQL", InsertSQL)

-- Example of InsertSQL:
-- exports['ata_core']:InsertSQL("users", {
--     name = "John Doe",
--     age = 25,
--     job = "Police"
-- })

-- Update rows matching conditions
local function UpdateSQL(tableName, data, where)
	if type(tableName) ~= "string" or type(data) ~= "table" or type(where) ~= "string" then
		return nil
	end

	local sets, params = {}, {}
	
	for column, value in pairs(data) do
		if type(column) == "string" then
			table.insert(sets, column .. "=?")
			table.insert(params, value)
		end
	end

	if #sets == 0 then return nil end

	local query = string.format(
		"UPDATE %s SET %s WHERE %s",
		tableName,
		table.concat(sets, ","),
		where
	)

	return ExecuteSQL(query, params)
end

exports("UpdateSQL", UpdateSQL)

-- Example of UpdateSQL:
-- exports['ata_core']:UpdateSQL("users", {
--     name = "John Smith",
--     age = 30
-- }, "id = 1")

-- Delete rows matching conditions
local function DeleteSQL(tableName, where)
	if type(tableName) ~= "string" or type(where) ~= "string" then
		return nil
	end

	local query = string.format("DELETE FROM %s WHERE %s", tableName, where)
	return ExecuteSQL(query)
end

exports("DeleteSQL", DeleteSQL)

-- Example of DeleteSQL:
-- exports['ata_core']:DeleteSQL("users", "id = 1")

-- Create table if it doesn't exist
local function CreateTableIfNotExists(tableName, columns)
	if type(tableName) ~= "string" or type(columns) ~= "table" then
		return nil
	end

	local columnDefs = {}
	
	for column, definition in pairs(columns) do
		if type(column) == "string" and type(definition) == "string" then
			table.insert(columnDefs, string.format("%s %s", column, definition))
		end
	end

	if #columnDefs == 0 then return nil end

	local query = string.format(
		"CREATE TABLE IF NOT EXISTS %s (%s)",
		tableName,
		table.concat(columnDefs, ", ")
	)

	return ExecuteSQL(query)
end

exports("CreateTableIfNotExists", CreateTableIfNotExists)

-- Find data in table and return result
local function FindSQL(tableName, column, where)
	if type(tableName) ~= "string" or type(column) ~= "string" or type(where) ~= "string" then
		return 'STRING ERROR'
	end

	local query = string.format("SELECT %s FROM %s WHERE %s", column, tableName, where)
	local result = ExecuteSQL(query)

	return result and result[1] and result[1][column] or false
end

exports("FindSQL", FindSQL)

-- Example of FindSQL:
-- local money = exports['ata_core']:FindSQL("users", "money", "identifier = 'license:123'")
