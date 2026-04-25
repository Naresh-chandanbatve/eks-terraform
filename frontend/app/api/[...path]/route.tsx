// app/api/[...path]/route.ts

export async function GET(
  req: Request,
  context: { params: Promise<{ path?: string[] }> }
) {
  try {
    // ✅ unwrap params
    const { path } = await context.params;

    const finalPath = path?.join("/") || "";

    const url = `http://backend/${finalPath}`;

    const res = await fetch(url, {
      cache: "no-store",
    });

    // ✅ safe parsing
    const text = await res.text();

    let data;
    try {
      data = JSON.parse(text);
    } catch {
      data = { raw: text };
    }

    return Response.json(data, {
      status: res.status,
    });

  } catch (err: any) {
    return Response.json(
      {
        error: "Proxy failed",
        details: err.message,
      },
      { status: 500 }
    );
  }
}