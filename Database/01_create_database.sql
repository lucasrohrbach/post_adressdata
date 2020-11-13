--------------------------------------------------------------------------------------
-- Database: Gritec.AddressData
-- Subject: Create Database
-- Description: Creates the database "Gritec.AddressData" with Recovery Model "Simple"
--------------------------------------------------------------------------------------
-- Rev | Date Modified | Developer		| Change Summary
--------------------------------------------------------------------------------------
-- 001 | 13.11.2020    | Martin Valer   | Initial version


------------------------------------------------------
-- Create Database
------------------------------------------------------
USE [master]
GO
CREATE DATABASE [Gritec.AddressData]
GO


------------------------------------------------------
-- Set Recovery Model to "Simple"
------------------------------------------------------
USE [master]
GO
ALTER DATABASE [Gritec.AddressData] SET RECOVERY SIMPLE ; 
GO
