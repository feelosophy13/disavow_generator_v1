<h1>Spammy Backlinks Disavow List Generator</h1>

<h3>Overview</h3>
<p>
One key aspect about a site's SEO is its backlinks profile. The goal is trying to create links from other authoritative sites (or directories) to point to your website. Legitimacy and relevancy of these linking sites are crucial because Google actually penalizes websites that 'receive' too many spammy backlinks from unqualified sites after it changed its SEO algorithm (see <a href="en.wikipedia.org/wiki/Google_Panda" target="_blank">Panda</a> and <a href="en_wikipedia.org/wiki/Google_Penguin" target="_blank">Penguin</a> update).
</p>
<p>
But what if I don't want to receive these spammy backlinks? Google fortunately equips all Google users with <a href="https://www.google.com/webmasters/tools/disavow-links-main?pli=1" target="_blank">Disavow Tool</a> where users can indicate to Google to disregard all backlinks coming from this list of domain names.When one's website has thousand hundreds of backlinks from hundreds of domains, generating this disavow list manually is heavily time-consuming and enervating. Using this tool, however, you can programmatically generate a disavow list at with a minimum effort.
</p>
<hr />

<h3>Prerequisite</h3>
You will need to have the following installed on your machine:
<ul>
	<li>Majestic SEO account</li>
	<li>R</li>
	<li>RStudio (optional)</li>
	<li>rjson package</li>
</ul>

<hr />

<h3>Folder Sitemap</h3>
<ul>
	<li>backlinkDisavow.R</li>
	<li>data</li>
	<ul>
		<li>directories_submitted</li>
		<ul>
			<li>sample_submitted_directories.txt</li>
		</ul>		
		<li>majestic_spreadsheet_data</li>
		<ul>
			<li>sample_spreadsheet_data.txt</li>
		</ul>
	</ul>	
	<li>output</li>
	<ul>
		<li>samplewebsite_org_disavowFinal_2013-08-09.txt</li>
	</ul>
	<li>README.md</li>
	<li>settings.json</li>	
</ul>

<hr />

<h3>Settings</h3> 
<p>
Executing the main program, backlinkDisavow.R will generate a disavow list inside the 'output' folder. Before running the program, make sure to visit settings.json and make sure the settings are configured properly.
</p>

 

<hr />

<h3>Future Plans</h3>
Since this program was initially developed for internal use only, it hasn't been optimized for general public usage. For one, users must be able to download backlink data from Majestic SEO, which is a premium service. It is also cumbersome to download this file and install R, RStudio, rjson package. For those reasons, I plan to create a web app version that does not require Majestic SEO account or installation of R and rjson package.    
