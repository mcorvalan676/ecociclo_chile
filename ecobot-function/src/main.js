export default async ({ req, res, log, error }) => {
  const apiKey = process.env.GEMINI_API_KEY;

  if (!apiKey) {
    return res.json({ error: 'Falta configurar GEMINI_API_KEY en las variables de entorno.' }, 500);
  }

  let payload;
  try {
    payload = JSON.parse(req.body || '{}');
  } catch (e) {
    return res.json({ error: 'Body inválido, se esperaba JSON.' }, 400);
  }

  const { message, history } = payload;

  if (!message || typeof message !== 'string') {
    return res.json({ error: 'El campo "message" es requerido.' }, 400);
  }

  const systemPrompt = `Eres "Eco", el asistente virtual de EcoCiclo Chile, una app de reciclaje.
Responde SIEMPRE en español, de forma breve, cálida y práctica.
Tu especialidad es reciclaje, reducción de residuos, puntos limpios y sustentabilidad en Chile.
Si te preguntan algo totalmente ajeno al reciclaje o sustentabilidad, redirige amablemente la conversación hacia esos temas.`;

  const contents = [
    ...(Array.isArray(history) ? history : []).map((h) => ({
      role: h.isUser ? 'user' : 'model',
      parts: [{ text: h.text }],
    })),
    { role: 'user', parts: [{ text: message }] },
  ];

  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          systemInstruction: { parts: [{ text: systemPrompt }] },
          contents,
        }),
      }
    );

    const data = await response.json();

    if (!response.ok) {
      error(JSON.stringify(data));
      return res.json({ error: 'Error al consultar el modelo de IA.' }, 502);
    }

    const reply =
      data.candidates?.[0]?.content?.parts?.[0]?.text ??
      'Lo siento, no pude generar una respuesta en este momento.';

    return res.json({ reply });
  } catch (e) {
    error(e.message);
    return res.json({ error: 'Error interno al procesar la solicitud.' }, 500);
  }
};