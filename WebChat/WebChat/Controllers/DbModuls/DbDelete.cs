﻿
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChat.Controllers.DbModuls
{
    public class DbDelete
    {
        static Models.ChatWebsiteEntities database = new Models.ChatWebsiteEntities();

        //su dung de xoa mot user ra khoi room khi user thoat khoi room
        public static void deleteUserFromRoom( int userID, int roomID)
        {
            var userinroom = from room_user in database.Room_Users
                             where room_user.UserID == userID && room_user.RoomID == roomID
                             select room_user;

            database.Room_Users.RemoveRange(userinroom);
            database.SaveChanges();
        }

        //thoat khoi phong 
        public static void GetOutOfRoom(int userID, int roomID)
        {
            deleteUserFromRoom(userID, roomID);
            //kiem tra quyen admin va trao quyen admin cho nguoi khac
            var room_user = DbModuls.DbGet.getUserInRoom(roomID);
            var room = DbModuls.DbGet.getSpecificRoom(roomID);
            if(room.RoomAdmin == userID)
            {
                var roomdatabase = database.ChatRooms.Single(r => r.RoomID == roomID);
                foreach (var item in room_user)
                {
                    if (item.UserID != userID)
                    {
                        roomdatabase.RoomAdmin = userID;
                        break;
                    }
                }
                database.SaveChanges();
            }       
        }


        public static void deleteRoom( int roomID)
        {
            //delete conversation first

            var roomconv = from conv in database.Conversations
                           where conv.RoomID == roomID
                           select conv;

            database.Conversations.RemoveRange(roomconv);

            //delete user-room relationship record

            var roomuser = from ru in database.Room_Users
                           where ru.RoomID == roomID
                           select ru;

            database.Room_Users.RemoveRange(roomuser);

            //delete room

            var room = from r in database.ChatRooms
                       where r.RoomID == roomID
                       select r;

            database.ChatRooms.RemoveRange(room);

            database.SaveChanges();
        }


        public static void deleteUser( int userID)
        {
            var user = ( from u in database.Users
                       where u.UserID == userID
                       select u ).FirstOrDefault();

            database.Users.Remove( user );
            database.SaveChanges();
        }
    }

}