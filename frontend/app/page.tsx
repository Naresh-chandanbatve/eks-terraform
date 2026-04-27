"use client";

import { useState } from "react";

export default function Home() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  const call = async (endpoint: string) => {
    setLoading(true);
    try {
      const res = await fetch(`/api/${endpoint}`);
      const text = await res.text();

      let json;
      try {
        json = JSON.parse(text);
      } catch {
        json = { raw: text };
      }

      setData(json);
    } catch (err: any) {
      setData({ error: err.message });
    }
    setLoading(false);
  };

  return (
    <div style={styles.container}>
      <h1 style={styles.title}>🚨 Incident Dashboard</h1>

      <div style={styles.buttonGrid}>
        <button style={styles.btn} onClick={() => call("data")}>
          Get Data
        </button>

        <button style={styles.btn} onClick={() => call("db-stress")}>
          DB Stress
        </button>

        <button style={styles.btn} onClick={() => call("slow")}>
          Slow API
        </button>

        <button style={styles.btn} onClick={() => call("random-fail")}>
          Random Fail
        </button>

        <button style={styles.dangerBtn} onClick={() => call("cache-break")}>
          Clear Cache
        </button>
      </div>

      {loading && <p style={styles.loading}>⏳ Loading...</p>}

      <div style={styles.outputBox}>
        <pre>{JSON.stringify(data, null, 2)}</pre>
      </div>
    </div>
  );
}

const styles: any = {
  container: {
    padding: "40px",
    fontFamily: "Arial, sans-serif",
    background: "#0f172a",
    minHeight: "100vh",
    color: "#e2e8f0",
  },
  title: {
    marginBottom: "20px",
  },
  buttonGrid: {
    display: "flex",
    gap: "12px",
    flexWrap: "wrap",
    marginBottom: "20px",
  },
  btn: {
    padding: "10px 16px",
    background: "#2563eb",
    border: "none",
    borderRadius: "6px",
    color: "white",
    cursor: "pointer",
  },
  dangerBtn: {
    padding: "10px 16px",
    background: "#dc2626",
    border: "none",
    borderRadius: "6px",
    color: "white",
    cursor: "pointer",
  },
  loading: {
    marginBottom: "10px",
  },
  outputBox: {
    background: "#020617",
    padding: "20px",
    borderRadius: "8px",
    border: "1px solid #1e293b",
    maxHeight: "400px",
    overflow: "auto",
  },
};