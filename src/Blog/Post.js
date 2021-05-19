import Elm from "react-elm-components";
import DividerLineReact from "../DividerLineReact.elm";
import SpinLoader from "../SpinLoader.elm";
import imageUrlBuilder from "@sanity/image-url";
import styles from "./Blog.module.css";

import React, { useEffect, useState } from "react";
import { useParams } from "react-router";
import { SanityClient, projectId, dataset } from "../SanityClient";
import BlockContent from "@sanity/block-content-to-react";
import { articleReadLength } from "./utils";

const Post = () => {
  const { slug } = useParams();
  const [post, setPost] = useState("loading");
  const builder = imageUrlBuilder(SanityClient);

  const serializers = {
    types: {
      code: (props) => (
        <pre data-language={props.node.language}>
          <code>{props.node.code}</code>
        </pre>
      ),
    },
  };

  const urlFor = (source) => builder.image(source);

  useEffect(() => {
    SanityClient.fetch(
      `*[_type == "post" && slug.current == "${slug}"]{author -> {name, image}, ...}`
    ).then((post) => {
      setPost(post[0]);
    });
  }, [slug]);

  const renderBlog = () => {
    if (post === "loading") {
      <p>Loading...</p>;
    } else if (post === undefined) {
      return (
        <>
          <h1 className={styles.noBlog}>No blog for you</h1>
          <Elm src={SpinLoader.Elm.SpinLoader} />
        </>
      );
    } else {
      return (
        <>
          <div className={styles.header}>
            <h1 className={styles.title}>{post.title}</h1>
            <div className={styles.line}>
              <Elm src={DividerLineReact.Elm.DividerLineReact} />
            </div>
            <div className={styles.ingress}>
              <BlockContent
                blocks={post.ingress}
                serializers={serializers}
                projectId={projectId}
                dataset={dataset}
              />
            </div>
            <div className={styles.headerBottom}>
              <div className={styles.headerInfoLeft}>
                <img
                  className={styles.authorImg}
                  src={urlFor(post.author.image).width(64)}
                />
                <div>
                  <p style={{ fontSize: 24 }}>{post.author.name}</p>
                  <p>{new Date(post._createdAt).toLocaleDateString("no-NB")}</p>
                </div>
              </div>
              <p className={styles.headerInfoRight}>
                Lesetid: ca.{articleReadLength(post.body)} minutter
              </p>
            </div>
            <img
	      alt={post.imgAlt}
              className={styles.responsive}
              src={urlFor(post.mainImage).width(1200)}
            />
          </div>
          <div className={styles.body}>
            <BlockContent
              blocks={post.body}
              serializers={serializers}
              projectId={projectId}
              dataset={dataset}
            />
          </div>
        </>
      );
    }
  };

  return <div className={styles.wrapper}>{renderBlog()}</div>;
};

export default Post;
