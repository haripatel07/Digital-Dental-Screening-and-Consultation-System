import React, { useEffect, useState } from 'react';
import { fetchArticles } from '../services/apiService';
import '../styles/Articles.css';

const Articles: React.FC = () => {
  const [articles, setArticles] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchArticles()
      .then(setArticles)
      .catch(err => setError(err.message))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="articles-list">Loading articles...</div>;
  if (error) return <div className="articles-list">Error: {error}</div>;

  return (
    <div className="articles-list">
      <h2>Dental Articles</h2>
      {articles.length === 0 && <div>No articles found.</div>}
      {articles.map((article, idx) => (
        <div key={idx} className="article-card">
          <h3>{article.title}</h3>
          <p>{article.summary || article.content}</p>
          {article.url && (
            <a href={article.url} target="_blank" rel="noopener noreferrer">
              Read more
            </a>
          )}
        </div>
      ))}
    </div>
  );
};

export default Articles;
