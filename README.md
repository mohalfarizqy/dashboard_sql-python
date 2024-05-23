<h1>Editorial Dashboard</h1>
<p>The dashboard being discussed can be found here as a PDF file: <a href='https://github.com/mohalfarizqy/dashboard_sql-python/blob/main/Editorial_Dashboard.pdf'>Editorial Dashboard PDF</a></p>

<h2>Big Question & Specifics</h2>
<p>This dashboard is designed to answer, descriptively, <b><i>why are our article views going down/up?</i></b> by addressing the following specific questions:</p>
<ul>
    <li>How might the number of published articles, Google clicks, and views from republishers contribute to this?</li>
    <ul>
        <li>How many articles have we published? What does this mean?</li>
        <li>How many views have we gotten from republishers? What does this mean?</li>
        <li>How many clicks have we gotten from Google? What does this mean?</li>
    </ul>
    <li>How does each section contribute to the article views?</li>
    <ul>
        <li>What are the top viewed sections?</li>
        <li>How is each section viewed on a daily basis?</li>
    </ul>
    <li>How many views do all published articles get?</li>
    <li>How can we improve our Google clicks?</li>
    <li>How can we improve our views from republishers?</li>
</ul>

<h2>Tools & Dataset</h2>
<p>Google Looker Studio, Google BigQuery, Google Search Console, Google Sheets/Microsoft Excel, and Jupyter Notebook/VS Code.</p>
<p>All SQL scripts are written in Google BigQuery. Jupyter Notebook is used to prepare and subset the data extracted from Google Search Console.</p>

<h2>Users: Newsroom Team & Digital Campaign Strategists</h2>
<p>The intended users of this dashboard are the editor-in-chief and editors. The <b>editor-in-chief</b> can get an <b>overview</b> of how content views are affected by newsroom productivity, republishers, and search engines. They can also <b>filter and zoom in</b> on each section, each editor, and each day to identify performing articles <b>in more detail</b>. This might be useful for tracking content view changes and identifying opportunities for improvement.</p>

<p><b>Editors</b> can find an <b>overview</b> of their own section by clicking on their section in the colored chart. By doing this, the dashboard will focus solely on the section of interest. Editors can also <b>filter and zoom in</b> on each topic and each day to identify top-performing topics and articles <b>in more detail</b>. This might be helpful for their topic planning, sifting through topics that need more attention.</p>

<p>Additionally, this dashboard can be used by campaign or digital strategists looking to connect relevant articles to the overall digital strategy. They can get an <b>overview</b> by filtering out the topics of interest. By doing this, the dashboard will focus solely on the topics at hand. Campaign strategists can also <b>filter and zoom in</b> on each section, each editor, and each day to get <b>more details</b> about which of them are performing better than others.</p>

<h2>Dashboard Type: Operational Dashboard</h2>
<p>This dashboard is an operational dashboard, where users can <b>actively monitor data on a daily basis</b>. Most of the charts are using Google BigQuery (SQL modeling) as their data sources, and it can change in 'real-time'. Some charts that were made of Google Search Console data sources can only be monitored in two to three days basis. There are only few charts that have constant values.</p>
    
<p>In the upper-right corner of the dashboard, users can find two practical <b>suggestions for improvement</b>: topic improvement (for SEO) and republisher improvement (for republishing). These suggestions are important for planning and upcoming projects.</p>
