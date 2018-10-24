package motivator.app.grabot.motiv8or

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        var et_user_name = findViewById(R.id.editText) as EditText
        var et_password = findViewById(R.id.editText2) as EditText
        var btn_submit = findViewById(R.id.button) as Button

        btn_submit.setOnClickListener {
            val user_name = et_user_name.text
            val password = et_password.text
            Toast.makeText(this@MainActivity, user_name, Toast.LENGTH_LONG).show()
        }
    }
}
