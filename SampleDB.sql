USE [master]
GO
/****** Object:  Database [SampleDB]    Script Date: 02-May-17 6:47:49 PM ******/
CREATE DATABASE [SampleDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SampleDB', FILENAME = N'E:\Study\SampleDB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SampleDB_log', FILENAME = N'E:\Study\SampleDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SampleDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SampleDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SampleDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SampleDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SampleDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SampleDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SampleDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SampleDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SampleDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SampleDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SampleDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SampleDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SampleDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SampleDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SampleDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SampleDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SampleDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SampleDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SampleDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SampleDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SampleDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SampleDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SampleDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SampleDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SampleDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SampleDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SampleDB] SET  MULTI_USER 
GO
ALTER DATABASE [SampleDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SampleDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SampleDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SampleDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SampleDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GetEndOfWeek]    Script Date: 02-May-17 6:47:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: Date Functions.sql|9|0|C:\Users\vjsurani\Desktop\Date Functions.sql

CREATE FUNCTION [dbo].[GetEndOfWeek] (@dDate datetime)
RETURNS datetime
AS
BEGIN
  DECLARE @dReturnDate datetime
  SET @dReturnDate = @dDate + (7 - (DATEPART(WEEKDAY, @dDate)))
  RETURN @dReturnDate
END

GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 02-May-17 6:47:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AuditLog](
	[TableName] [varchar](max) NOT NULL,
	[PrimaryKey] [varchar](max) NOT NULL,
	[ColName] [varchar](max) NOT NULL,
	[OldValue] [varchar](max) NOT NULL,
	[NewValue] [varchar](max) NOT NULL,
	[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrderHdr]    Script Date: 02-May-17 6:47:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderHdr](
	[Id] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[Amount] [decimal](14, 2) NOT NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Price]    Script Date: 02-May-17 6:47:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Price](
	[Id] [int] NOT NULL,
	[ProductName] [varchar](100) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Price] [decimal](14, 2) NOT NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[AuditLog] ([TableName], [PrimaryKey], [ColName], [OldValue], [NewValue], [LastUpdate]) VALUES (N'PRICE', N'1', N'Price', N'30000.00', N'35000.00', CAST(0x0000A7670109BEF5 AS DateTime))
INSERT [dbo].[AuditLog] ([TableName], [PrimaryKey], [ColName], [OldValue], [NewValue], [LastUpdate]) VALUES (N'PRICE', N'1', N'Description', N'Sony', N'Sony Bravia', CAST(0x0000A767010B2807 AS DateTime))
INSERT [dbo].[OrderHdr] ([Id], [OrderDate], [Amount], [LastUpdate]) VALUES (1, CAST(0x0000A75E00000000 AS DateTime), CAST(300.00 AS Decimal(14, 2)), CAST(0x0000A76700FFFE72 AS DateTime))
INSERT [dbo].[OrderHdr] ([Id], [OrderDate], [Amount], [LastUpdate]) VALUES (2, CAST(0x0000A76100000000 AS DateTime), CAST(500.00 AS Decimal(14, 2)), CAST(0x0000A76701001E89 AS DateTime))
INSERT [dbo].[OrderHdr] ([Id], [OrderDate], [Amount], [LastUpdate]) VALUES (3, CAST(0x0000A76400000000 AS DateTime), CAST(2000.00 AS Decimal(14, 2)), NULL)
INSERT [dbo].[OrderHdr] ([Id], [OrderDate], [Amount], [LastUpdate]) VALUES (4, CAST(0x0000A76500000000 AS DateTime), CAST(500.00 AS Decimal(14, 2)), CAST(0x0000A76701001E89 AS DateTime))
INSERT [dbo].[Price] ([Id], [ProductName], [Description], [Price], [LastUpdate]) VALUES (1, N'Sony Bravia TV', N'Sony Bravia', CAST(35000.00 AS Decimal(14, 2)), CAST(0x0000A767010B2807 AS DateTime))
INSERT [dbo].[Price] ([Id], [ProductName], [Description], [Price], [LastUpdate]) VALUES (2, N'Whirpool Refrigerator', N'Whirpool', CAST(18000.00 AS Decimal(14, 2)), NULL)
INSERT [dbo].[Price] ([Id], [ProductName], [Description], [Price], [LastUpdate]) VALUES (3, N'Symphony Cooler', N'Symphony', CAST(8000.00 AS Decimal(14, 2)), NULL)
USE [master]
GO
ALTER DATABASE [SampleDB] SET  READ_WRITE 
GO
