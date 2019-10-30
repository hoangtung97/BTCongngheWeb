USE [master]
GO
/****** Object:  Database [ChatWebsite]    Script Date: 30-Oct-19 8:32:01 AM ******/
CREATE DATABASE [ChatWebsite]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ChatWebsite', FILENAME = N'F:\4th Year Projects\Web Technology\ChatWebsite\BTCongngheWeb\ChatWebsite.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ChatWebsite_log', FILENAME = N'F:\4th Year Projects\Web Technology\ChatWebsite\BTCongngheWeb\ChatWebsite_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [ChatWebsite] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ChatWebsite].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ChatWebsite] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ChatWebsite] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ChatWebsite] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ChatWebsite] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ChatWebsite] SET ARITHABORT OFF 
GO
ALTER DATABASE [ChatWebsite] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ChatWebsite] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ChatWebsite] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ChatWebsite] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ChatWebsite] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ChatWebsite] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ChatWebsite] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ChatWebsite] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ChatWebsite] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ChatWebsite] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ChatWebsite] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ChatWebsite] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ChatWebsite] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ChatWebsite] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ChatWebsite] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ChatWebsite] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ChatWebsite] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ChatWebsite] SET RECOVERY FULL 
GO
ALTER DATABASE [ChatWebsite] SET  MULTI_USER 
GO
ALTER DATABASE [ChatWebsite] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ChatWebsite] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ChatWebsite] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ChatWebsite] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ChatWebsite] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ChatWebsite', N'ON'
GO
ALTER DATABASE [ChatWebsite] SET QUERY_STORE = OFF
GO
USE [ChatWebsite]
GO
/****** Object:  Table [dbo].[ChatRoom]    Script Date: 30-Oct-19 8:32:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatRoom](
	[RoomID] [int] NOT NULL,
	[RoomName] [nvarchar](50) NULL,
	[RoomAdmin] [int] NULL,
	[RoomPW] [char](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conversations]    Script Date: 30-Oct-19 8:32:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conversations](
	[RoomID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[_Time] [datetime] NOT NULL,
	[Content] [nvarchar](200) NULL,
 CONSTRAINT [Conv_PK] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC,
	[UserID] ASC,
	[_Time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room_Users]    Script Date: 30-Oct-19 8:32:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room_Users](
	[RoomID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Socket] [char](50) NULL,
 CONSTRAINT [Room_Users_PK] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 30-Oct-19 8:32:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[DisplayName] [nvarchar](50) NOT NULL,
	[Password_] [char](16) NOT NULL,
	[Avatar] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChatRoom]  WITH CHECK ADD FOREIGN KEY([RoomAdmin])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Conversations]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[ChatRoom] ([RoomID])
GO
ALTER TABLE [dbo].[Conversations]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Room_Users]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[ChatRoom] ([RoomID])
GO
ALTER TABLE [dbo].[Room_Users]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
/****** Object:  StoredProcedure [dbo].[Log_In]    Script Date: 30-Oct-19 8:32:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Log_In]( @username nvarchar(50), @password char(16) )
as
begin
	set nocount on;
	declare @userid int

	select @userid = UserID from dbo.Users
	where Username = @username and Password_ = @password

	if @userid is not null
	begin
		select @userID[UserID] 
	end
	else
	begin
		select -1
	end
end
GO
USE [master]
GO
ALTER DATABASE [ChatWebsite] SET  READ_WRITE 
GO
