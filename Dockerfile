FROM squidfunk/mkdocs-material:latest

RUN pip install --no-cache-dir \
    mkdocs-git-revision-date-localized-plugin \
    mkdocs-glightbox

EXPOSE 8000
WORKDIR /docs
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]