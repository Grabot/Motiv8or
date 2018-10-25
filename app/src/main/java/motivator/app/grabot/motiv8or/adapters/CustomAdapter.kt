package motivator.app.grabot.motiv8or.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Button
import android.widget.TextView
import motivator.app.grabot.motiv8or.R
import motivator.app.grabot.motiv8or.activities.HomeActivity

class CustomAdapter(private val context: Context) : BaseAdapter() {

    override fun getViewTypeCount(): Int {
        return count
    }

    override fun getItemViewType(position: Int): Int {

        return position
    }

    override fun getCount(): Int {
        return HomeActivity.modelArrayList.size
    }

    override fun getItem(position: Int): Any {
        return HomeActivity.modelArrayList.get(position)
    }

    override fun getItemId(position: Int): Long {
        return 0
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        var convertView = convertView
        val holder: ViewHolder

        if (convertView == null) {
            holder = ViewHolder()
            val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
            convertView = inflater.inflate(R.layout.item_home, null, true)


            holder.feedItem = convertView!!.findViewById(R.id.feedItem) as TextView
            holder.btn_plus = convertView.findViewById(R.id.feedButton) as Button

            convertView.tag = holder
        } else {
            // the getTag returns the viewHolder object set as a tag to the view
            holder = convertView.tag as ViewHolder
        }

        holder.feedItem!!.setText(HomeActivity.modelArrayList.get(position).getFeed())

        return convertView
    }

    private inner class ViewHolder {
        var btn_plus: Button? = null
        var feedItem: TextView? = null
    }

}