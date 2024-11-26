# DCGAN

DCGAN (Deep Convolutional Generative Adversarial Networks)

We simultaneously train two models: a generative model $G$ that captures the data distribution, and a discriminative model $D$ that estimates the probability that a sample came from the training data rather than $G$.

$D$ and $G$ play the following two-player minimax game with value function $V(G, D)$: 

$$
\min_G \max_D V(D, G) = \mathbb{E}_{\bm{x} \sim p_{\text{data}}(\bm{x})}[\log D(\bm{x})] + \mathbb{E}_{\bm{z} \sim p_{\bm{z}}(\bm{z})}[\log (1 - D(G(\bm{z})))].
$$

This translates into two minimization problems:

$$
\min_D -\mathbb{E}_{\bm{x} \sim p_{\text{data}}(\bm{x})}[\log D(\bm{x})] - \mathbb{E}_{\bm{z} \sim p_{\bm{z}}(\bm{z})}[\log (1 - D(G(\bm{z})))]
$$

$$
\min_G \mathbb{E}_{\bm{z} \sim p_{\bm{z}}(\bm{z})}[\log (1 - D(G(\bm{z})))]
$$

For $G$, we use the following loss instead:

$$
\min_G -\mathbb{E}_{\bm{z} \sim p_{\bm{z}}(\bm{z})}[\log (D(G(\bm{z})))]
$$

---
In summary,

$$
\min_D \mathbb{E}_{\bm{x} \sim p_{\text{data}}(\bm{x})}[-\log D(\bm{x})] + \mathbb{E}_{\bm{z} \sim p_{\bm{z}}(\bm{z})}[-\log (1 - D(G(\bm{z})))]
$$

$$
\min_G \mathbb{E}_{\bm{z} \sim p_{\bm{z}}(\bm{z})}[-\log (D(G(\bm{z})))]
$$

In practice,

$$
\min_D \text{BCELoss}(D(x), 1) + \text{BCELoss}(D(G(z)), 0)
$$

$$
\min_G \text{BCELoss}(D(G(z)), 1)
$$

because $\text{BCELoss}(x, y) = -(y\log x + (1-y)\log(1-x))$.

## Training

### PyTorch

```
python train_torch.py
```

### Lightning Fabric

```
python train_fabric.py
```

### Acclerate

```
accelerate config
```

```
accelerate launch train_accelerate.py
```


## References
- https://github.com/pytorch/examples/tree/main/dcgan
- https://github.com/Lightning-AI/pytorch-lightning/tree/master/examples/fabric/dcgan
- https://github.com/huggingface/community-events/tree/main/huggan/pytorch/dcgan