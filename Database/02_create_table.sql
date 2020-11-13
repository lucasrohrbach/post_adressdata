--------------------------------------------------------------------------------------
-- Database: Gritec.AddressData
-- Subject: Create Database
-- Description: Creates the tables for DB "Gritec.AddressData"
--------------------------------------------------------------------------------------
-- Rev | Date Modified | Developer		| Change Summary
--------------------------------------------------------------------------------------
-- 001 | 13.11.2020    | Martin Valer   | Initial version
--


USE [Gritec.AddressData]
GO

------------------------------------------------------
-- Create Table Ort
------------------------------------------------------
CREATE TABLE [dbo].[Ort](
	[ONRP] [int] NOT NULL,
	[PLZ] [int] NOT NULL,
	[Ort] [nvarchar](18) NOT NULL,
	[Kanton] [nvarchar](2) NULL,
 CONSTRAINT [PK_Ort] PRIMARY KEY CLUSTERED 
(
	[ONRP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO