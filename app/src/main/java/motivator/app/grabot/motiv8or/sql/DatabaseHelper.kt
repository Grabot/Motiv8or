package motivator.app.grabot.motiv8or.sql

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    // create table query
    private val CREATE_USER_TABLE = ("create table " + TABLE_USER
            + "(" + COLUMN_USER_ID + " integer primary key autoincrement," + COLUMN_USER_NAME + " text, "
            + COLUMN_USER_EMAIL + " text," + COLUMN_USER_PASSWORD + " text" + ")")

    // drop table query
    private val DROP_USER_TABLE = "drop table if exists $TABLE_USER"

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(CREATE_USER_TABLE)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        // drop user table and create it again
        db.execSQL(DROP_USER_TABLE)
        onCreate(db)
    }

    companion object {
        // Database Version
        private val DATABASE_VERSION = 1

        // Database Name
        private val DATABASE_NAME = "UserManager.db"

        // User table name
        private val TABLE_USER = "user"

        // User Table Columns names
        private val COLUMN_USER_ID = "user_id"
        private val COLUMN_USER_NAME = "user_name"
        private val COLUMN_USER_EMAIL = "user_email"
        private val COLUMN_USER_PASSWORD = "user_password"
    }
}