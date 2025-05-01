
# arxiv-sanity-lite

A much lighter-weight arxiv-sanity from-scratch re-write. Periodically polls arxiv API for new papers. Then allows users to tag papers of interest, and recommends new papers for each tag based on SVMs over tfidf features of paper abstracts. Allows one to search, rank, sort, slice and dice these results in a pretty web UI. Lastly, arxiv-sanity-lite can send you daily emails with recommendations of new papers based on your tags. Curate your tags, track recent papers in your area, and don't miss out!

I am running a live version of this code on [arxiv-sanity-lite.com](https://arxiv-sanity-lite.com).

![Screenshot](screenshot.jpg)

#### To run

To run this locally I usually run the script `update_paper_database` to update the database with any new papers.

```bash
#!/bin/bash

uv run python arxiv_daemon.py --num 2000

if [ $? -eq 0 ]; then
    echo "New papers detected! Running compute.py"
    uv run python compute.py
else
    echo "No new papers were added, skipping feature computation"
fi
```
You can schedule this via a periodic cron job. First, you need to run the command `crontab -e` to open your 
crontab editor, and then add the following line:

```bash
0 2 * * * cd <path-to-this-repo> && /bin/bash update_paper_database.sh >> cron.log 2>&1
```
This runs the script every day at 2:00 AM, logs output to `cron.log` in the same folder, and redirects errors to the
same file.


You can see that updating the database is a matter of first downloading the new papers via the arxiv api using `arxiv_daemon.py`, and then running `compute.py` to compute the tfidf features of the papers. Finally to serve the flask server locally we'd run something like:

```bash
export FLASK_APP=serve.py; uv run flask run >> flask.log 2>&1 &
```
This puts the Flask server in the background and logs output. You now can access to `arxiv-sanity` by navigating to
`127.0.0.1:5000`.

All of the database will be stored inside the `data` directory. Finally, if you'd like to run your own instance on the interwebs I recommend simply running the above on a [Linode](https://www.linode.com), e.g. I am running this code currently on the smallest "Nanode 1 GB" instance indexing about 30K papers, which costs $5/month.

(Optional) Finally, if you'd like to send periodic emails to users about new papers, see the `send_emails.py` script. You'll also have to `pip install sendgrid`. I run this script in a daily cron job.

#### Requirements

I recommend using [uv](https://docs.astral.sh/uv/) to manage python packages and their dependencies.

First, we need to create a virtual environment. From the root of this repository, run:

```bash
uv venv
```
You should see a new folder with name `.venv` created.

Next, install the required packages:

```bash
 uv pip install -r requirements.txt
```

#### Todos

- Make website mobile friendly with media queries in css etc
- The metas table should not be a sqlitedict but a proper sqlite table, for efficiency
- Build a reverse index to support faster search, right now we iterate through the entire database

#### License

MIT
